package types

import (
	errorsmod "cosmossdk.io/errors"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgSendIbcPost{}

func NewMsgSendIbcPost(
	creator string,
	port string,
	channelID string,
	timeoutTimestamp uint64,
	title string,
	content string,
) *MsgSendIbcPost {
	return &MsgSendIbcPost{
		Creator:          creator,
		Port:             port,
		ChannelID:        channelID,
		TimeoutTimestamp: timeoutTimestamp,
		Title:            title,
		Content:          content,
	}
}

func (msg *MsgSendIbcPost) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return errorsmod.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	if msg.Port == "" {
		return errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "invalid packet port")
	}
	if msg.ChannelID == "" {
		return errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "invalid packet channel")
	}
	if msg.TimeoutTimestamp == 0 {
		return errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "invalid packet timeout")
	}
	return nil
}
