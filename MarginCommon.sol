pragma solidity 0.4.24;

import { MarginState } from "./MarginState.sol";
import { Vault } from "./Vault.sol";

library MarginCommon {
    struct Position {
        address owedToken;
        address heldToken;
        address lender;
        address owner;
        uint256 principal;
        uint256 requiredDeposit;
        uint32  callTimeLimit;
        uint32  startTimestamp;  // cannot be 0
        uint32  callTimestamp;
        uint32  maxDuration;
        uint32  interestRate;
        uint32  interestPeriod;
    }

    function getPositionFromStorage(
        MarginState.State storage state,
        bytes32 positionId
    )
        internal
        view
        returns (Position storage)
    {
        Position storage position = state.positions[positionId];

        require(
            position.startTimestamp != 0,
            "MarginCommon#getPositionFromStorage: The position does not exist"
        );

        return position;
    }

    function getPositionBalanceImpl(
        MarginState.State storage state,
        bytes32 positionId
    )
        internal
        view
        returns(uint256)
    {
        return Vault(state.VAULT).balances(positionId, state.positions[positionId].heldToken);
    }