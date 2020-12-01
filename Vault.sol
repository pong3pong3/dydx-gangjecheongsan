import { SafeMath } from "openzeppelin-solidity/contracts/math/SafeMath.sol";
import { TokenInteract } from "./TokenInteract.sol";

pragma solidity 0.4.24;

contract Vault
{
    using SafeMath for uint256;

    // Map from vault ID to map from token address to amount of that token attributed to the
    // particular vault ID.
    mapping (bytes32 => mapping (address => uint256)) public balances;

    /**
     * Transfers a certain amount of funds to an address.
     *
     * @param  id      The vault from which to send the tokens
     * @param  token   ERC20 token address
     * @param  to      Address to transfer tokens to
     * @param  amount  Number of the token to be sent
     */

    function transferFromVault(
        bytes32 id,
        address token,
        address to,
        uint256 amount
    )
        external
        requiresAuthorization
    {
        balances[id][token] = balances[id][token].sub(amount);

        // Do the sending
        TokenInteract.transfer(token, to, amount);
    }
}
