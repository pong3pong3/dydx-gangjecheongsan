pragma solidity 0.4.24;

import { SafeMath } from "openzeppelin-solidity/contracts/math/SafeMath.sol";
import { MarginCommon } from "./MarginCommon.sol";
import { MarginState } from "./MarginState.sol";
import { Vault } from "./Vault.sol";

library ForceRecoverCollateralImpl {
    using SafeMath for uint256;

    function forceRecoverCollateralImpl(
        MarginState.State storage state,
        bytes32 positionId,
        address recipient
    )
        public
        returns (uint256)
    {
        MarginCommon.Position storage position =
            MarginCommon.getPositionFromStorage(state, positionId);

        // Can only force recover after either:
        // 1) The loan was called and the call period has elapsed
        // 2) The maxDuration of the position has elapsed
        require(
            (
                position.callTimestamp > 0
                && block.timestamp >= uint256(position.callTimestamp).add(position.callTimeLimit)
            ) || (
                block.timestamp >= uint256(position.startTimestamp).add(position.maxDuration)
            ),
            "ForceRecoverCollateralImpl#forceRecoverCollateralImpl: Cannot recover yet"
        );

        uint256 heldTokenRecovered = MarginCommon.getPositionBalanceImpl(state, positionId);
        Vault(state.VAULT).transferFromVault(
            positionId,
            position.heldToken,
            recipient,
            heldTokenRecovered
        );

        emit CollateralForceRecovered(
            positionId,
            recipient,
            heldTokenRecovered
        );

        return heldTokenRecovered;
    }

    event CollateralForceRecovered(
        bytes32 indexed positionId,
        address indexed recipient,
        uint256 amount
    );
}