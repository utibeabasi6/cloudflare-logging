package externaljsonprocessor

import (
	"context"
	"time"

	"github.com/utibeabasi6/cloudflare-logging/otel/otelcol/processors/externaljsonprocessor/internal/metadata"
	"go.opentelemetry.io/collector/component"
	"go.opentelemetry.io/collector/consumer"
	"go.opentelemetry.io/collector/processor"
	"go.opentelemetry.io/collector/processor/processorhelper"
)

// NewFactory creates a factory for the routing processor.
func NewFactory() processor.Factory {
	return processor.NewFactory(
		metadata.Type,
		createDefaultConfig,
		processor.WithLogs(createLogsProcessor, metadata.LogsStability),
	)
}

func createDefaultConfig() component.Config {
	return &Config{}
}

func createLogsProcessor(
	ctx context.Context,
	set processor.CreateSettings,
	cfg component.Config,
	nextConsumer consumer.Logs,
) (processor.Logs, error) {
	metadataSvc := metadataService{
		cfg:      cfg,
		logger:   set.Logger,
		metadata: &[]metadataData{},
	}

	ticker := time.NewTicker(5 * time.Second)
	done := make(chan bool)

	// Fetch metadata every 5 seconds
	go func() {
		for {
			select {
			case <-done:
				return
			case t := <-ticker.C:
				metadataSvc.populateMetadata(t)
			}
		}
	}()

	return processorhelper.NewLogsProcessor(
		ctx,
		set,
		cfg,
		nextConsumer,
		metadataSvc.enrichLogs,
		processorhelper.WithCapabilities(consumer.Capabilities{MutatesData: true}),
	)

}
