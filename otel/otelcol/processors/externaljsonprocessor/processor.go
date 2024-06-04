package externaljsonprocessor

import (
	"context"
	"fmt"
	"io"
	"net/http"
	"sync"

	"go.opentelemetry.io/collector/pdata/plog"
	"go.uber.org/zap"
)

type metadataData struct {
	key   string
	value string
}

type metadataService struct {
	cfg      *Config
	logger   *zap.Logger
	metadata *[]metadataData
	mu       sync.Mutex
}

func (m *metadataService) populateMetadata() error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if len(m.cfg.MetadataPaths) == 0 {
		return nil
	}
	// fetch mmdsv2 token
	token, err := m.fetchMMDSToken()
	if err != nil {
		m.logger.Log(zap.ErrorLevel, err.Error())
		// TODO: handle error better
		return err
	}

	// TODO: timeout fetching the data after the metadata token has expired
	metadataDataChan := make(chan *metadataData, len(m.cfg.MetadataPaths))
	wg := sync.WaitGroup{}

	for _, path := range m.cfg.MetadataPaths {
		wg.Add(1)
		metadataPath := path
		go func() {
			defer wg.Done()
			mmdsData, err := m.fetchMMDSData(*token, metadataPath)
			if err != nil {
				// TODO: probably need to return the error?
				m.logger.Log(zap.ErrorLevel, err.Error())
			}
			metadataDataObj := metadataData{key: metadataPath, value: *mmdsData}
			metadataDataChan <- &metadataDataObj
		}()
	}

	wg.Wait()
	close(metadataDataChan)

	var metadataDataArray []metadataData

	for data := range metadataDataChan {
		metadataDataArray = append(metadataDataArray, *data)
	}
	m.metadata = &metadataDataArray

	return nil

}

func (m *metadataService) fetchMMDSToken() (*string, error) {
	var token string
	mmdsTokenUrl := fmt.Sprintf("http://%s/latest/api/token", MMDSIP)
	req, err := http.NewRequest(http.MethodPut, mmdsTokenUrl, nil)
	if err != nil {
		return nil, err
	}

	req.Header.Set("X-aws-ec2-metadata-token-ttl-seconds", fmt.Sprint(MetadataFetchTimeoutSeconds))
	// TODO: use fetch client with context and add timeout
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}

	body, err := io.ReadAll(res.Body)
	if err != nil {
		return nil, err
	}

	token = string(body)
	return &token, nil
}

func (m *metadataService) fetchMMDSData(token, path string) (*string, error) {
	var mmdsData string
	mmdsUrl := fmt.Sprintf("http://%s/latest/meta-data/%s", MMDSIP, path)
	req, err := http.NewRequest(http.MethodGet, mmdsUrl, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("X-aws-ec2-metadata-token", token)
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}

	body, err := io.ReadAll(res.Body)
	if err != nil {
		return nil, err
	}

	mmdsData = string(body)
	return &mmdsData, nil
}

func (m *metadataService) enrichLogs(ctx context.Context, logs plog.Logs) (plog.Logs, error) {
	if len(*m.metadata) > 0 {
		for i := 0; i < logs.ResourceLogs().Len(); i++ {
			resourceLog := logs.ResourceLogs().At(i)
			for s := 0; s < resourceLog.ScopeLogs().Len(); s++ {
				scopeLog := resourceLog.ScopeLogs().At(s)
				for l := 0; l < scopeLog.LogRecords().Len(); l++ {
					logRecord := scopeLog.LogRecords().At(l)
					attrMap := logRecord.Attributes().PutEmptyMap(InstanceMetadataAttributeKey)
					for _, val := range *m.metadata {
						attrMap.PutStr(val.key, val.value)
					}
				}
			}
		}
	}
	return logs, nil
}
