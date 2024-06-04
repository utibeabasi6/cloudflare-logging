package externaljsonprocessor

import (
	"context"
	"sync"
	"time"

	"go.opentelemetry.io/collector/component"
	"go.opentelemetry.io/collector/pdata/plog"
	"go.uber.org/zap"
)

type metadataData struct {
	key   string
	value string
}

type metadataService struct {
	cfg      component.Config
	logger   *zap.Logger
	metadata *[]metadataData
	mu       sync.Mutex
}

func (m *metadataService) populateMetadata(t time.Time) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.metadata = &[]metadataData{metadataData{key: "hello", value: "world"}}
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
