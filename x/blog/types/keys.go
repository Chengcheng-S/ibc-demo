package types

const (
	// ModuleName defines the module name
	ModuleName = "blog"

	// StoreKey defines the primary module store key
	StoreKey = ModuleName

	// MemStoreKey defines the in-memory store key
	MemStoreKey = "mem_blog"

	// Version defines the current version the IBC module supports
	Version = "blog-1"

	// PortID is the default port id that module binds to
	PortID = "blog"
)

var (
	ParamsKey = []byte("p_blog")
)

var (
	// PortKey defines the key to store the port ID in store
	PortKey = KeyPrefix("blog-port-")
)

func KeyPrefix(p string) []byte {
	return []byte(p)
}

const (
	PostKey      = "Post/value/"
	PostCountKey = "Post/count/"
)

const (
	SentPostKey      = "SentPost/value/"
	SentPostCountKey = "SentPost/count/"
)

const (
	TimeoutPostKey      = "TimeoutPost/value/"
	TimeoutPostCountKey = "TimeoutPost/count/"
)
