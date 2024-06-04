package externaljsonprocessor

type Config struct {
	Local bool `mapstructure:"local"`
}

func (cfg *Config) Validate() error {
	return nil
}

const (
	InstanceMetadataAttributeKey = "instance_metadata"
)
