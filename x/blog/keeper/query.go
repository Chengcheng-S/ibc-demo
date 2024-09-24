package keeper

import (
	"plante/x/blog/types"
)

var _ types.QueryServer = Keeper{}
