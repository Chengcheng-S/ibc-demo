package keeper

import (
	"context"

	"plante/x/blog/types"

	errorsmod "cosmossdk.io/errors"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	clienttypes "github.com/cosmos/ibc-go/v8/modules/core/02-client/types"
)

func (k msgServer) SendIbcPost(goCtx context.Context, msg *types.MsgSendIbcPost) (*types.MsgSendIbcPostResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	//validate incoming msgs
	if _, err := sdk.AccAddressFromBech32(msg.Creator); err != nil {
		return nil, errorsmod.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	if msg.Port == "" {
		return nil, errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "invalid packet port")
	}
	if msg.ChannelID == "" {
		return nil, errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "invalid packet channel")
	}
	if msg.TimeoutTimestamp == 0 {
		return nil, errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "invalid packet timeout")
	}

	// TODO: logic before transmitting the packet

	// Construct the packet
	var packet types.IbcPostPacketData

	packet.Title = msg.Title
	packet.Content = msg.Content
	packet.Creator = msg.Creator

	// Transmit the packet
	_, err := k.TransmitIbcPostPacket(
		ctx,
		packet,
		msg.Port,
		msg.ChannelID,
		clienttypes.ZeroHeight(),
		msg.TimeoutTimestamp,
	)
	if err != nil {
		return nil, err
	}

	return &types.MsgSendIbcPostResponse{}, nil
}
