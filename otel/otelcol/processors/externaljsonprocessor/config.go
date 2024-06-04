package externaljsonprocessor

type Config struct {
	Local         bool     `mapstructure:"local"`
	MetadataPaths []string `mapstructure:"metadata_paths"`
}

func (cfg *Config) Validate() error {
	return nil
}

const (
	InstanceMetadataAttributeKey = "instance_metadata"
	MMDSIP                       = "169.254.169.254"
	MetadataFetchTimeoutSeconds  = 100
)
