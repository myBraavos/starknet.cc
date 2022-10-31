// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.2.1 (token/erc20/library.cairo)

%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero, assert_le, assert_lt
from starkware.cairo.common.bool import FALSE, TRUE
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_check,
    uint256_eq,
    uint256_not,
    uint256_le,
)

from openzeppelin.security.safemath import SafeUint256
from openzeppelin.access.ownable import Ownable
from openzeppelin.utils.constants import UINT8_MAX

//
// Events
//

@event
func Transfer(from_: felt, to: felt, value: Uint256) {
}

@event
func Approval(owner: felt, spender: felt, value: Uint256) {
}

//
// Storage
//

@storage_var
func ERC20_name() -> (name: felt) {
}

@storage_var
func ERC20_symbol() -> (symbol: felt) {
}

@storage_var
func ERC20_decimals() -> (decimals: felt) {
}

@storage_var
func ERC20_total_supply() -> (total_supply: Uint256) {
}

@storage_var
func ERC20_balances(account: felt) -> (balance: Uint256) {
}

@storage_var
func ERC20_allowances(owner: felt, spender: felt) -> (allowance: Uint256) {
}

namespace ERC20 {
    //
    // Initializer
    //

    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        name: felt, symbol: felt, decimals: felt
    ) {
        ERC20_name.write(name);
        ERC20_symbol.write(symbol);
        with_attr error_message("ERC20: decimals exceed 2^8") {
            assert_lt(decimals, UINT8_MAX);
        }
        ERC20_decimals.write(decimals);
        return ();
    }

    //
    // Public functions
    //

    func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
        let (name) = ERC20_name.read();
        return (name,);
    }

    func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        symbol: felt
    ) {
        let (symbol) = ERC20_symbol.read();
        return (symbol,);
    }

    func total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        total_supply: Uint256
    ) {
        let (total_supply: Uint256) = ERC20_total_supply.read();
        return (total_supply,);
    }

    func decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        decimals: felt
    ) {
        let (decimals) = ERC20_decimals.read();
        return (decimals,);
    }

    func balance_of{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        account: felt
    ) -> (balance: Uint256) {
        let (balance: Uint256) = ERC20_balances.read(account);
        return (balance,);
    }

    //
    // Internal
    //
    func _mint_ctor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        recipient: felt, amount: Uint256
    ) {
        alloc_locals;
        with_attr error_message("ERC20: amount is not a valid Uint256") {
            uint256_check(amount);
        }

        with_attr error_message("ERC20: cannot mint to the zero address") {
            assert_not_zero(recipient);
        }

        let (balance: Uint256) = ERC20_balances.read(account=recipient);
        let (new_balance: Uint256) = SafeUint256.add(balance, amount);
        let (supply: Uint256) = ERC20_total_supply.read();
        with_attr error_message("ERC20: mint overflow") {
            let (new_supply: Uint256) = SafeUint256.add(supply, amount);
        }
        ERC20_total_supply.write(new_supply);
        ERC20_balances.write(recipient, new_balance);

        Transfer.emit(0, recipient, amount);
        return ();
    }

    func _mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        recipient: felt, amount: Uint256
    ) {
        alloc_locals;
        let max_mint_amount_per_address: Uint256 = Uint256(low=100, high=0);
        let max_mint_amount_per_mint: Uint256 = Uint256(low=50, high=0);
        with_attr error_message("ERC20: amount is not a valid Uint256") {
            uint256_check(amount);
        }

        with_attr error_message("ERC20: cannot mint to the zero address") {
            assert_not_zero(recipient);
        }

        let (mint_amount_valid: felt) = uint256_le(amount, max_mint_amount_per_mint);
        // Minting is limited to 100 token per transaction
        with_attr error_message("Lame ERC20: Can only mint 50 tokens at a time") {
            assert_not_zero(mint_amount_valid);
        }

        let (balance: Uint256) = ERC20_balances.read(account=recipient);
        let (new_balance: Uint256) = SafeUint256.add(balance, amount);
        // Non owner - minting is limited
        let (owner: felt) = Ownable.owner();
        let (caller) = get_caller_address();
        let (new_balance_valid) = uint256_le(new_balance, max_mint_amount_per_address);
        if (caller != owner) {
            with_attr error_message(
                    "Lame ERC20: Only owner can mint more than 100 tokens per address") {
                assert new_balance_valid = TRUE;
            }
        }

        let (supply: Uint256) = ERC20_total_supply.read();
        with_attr error_message("ERC20: mint overflow") {
            let (new_supply: Uint256) = SafeUint256.add(supply, amount);
        }
        ERC20_total_supply.write(new_supply);
        ERC20_balances.write(recipient, new_balance);

        Transfer.emit(0, recipient, amount);
        return ();
    }
}
