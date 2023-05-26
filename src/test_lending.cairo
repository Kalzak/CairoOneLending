use src::Lending;

use starknet::ContractAddress;

use starknet::Felt252TryIntoContractAddress;

use starknet::TryInto;
use starknet::OptionTrait;

#[test]
#[available_gas(2000000)]
fn can_initialize() {
    let token: ContractAddress = gen_address(111);
    Lending::initialize(token);
    let asset_token = Lending::get_asset_token();
    assert(token == asset_token, 'Asset token not set');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Already initialized',))]
fn cannot_initialize_twice() {
    let token: ContractAddress = gen_address(111);
    Lending::initialize(token);
    Lending::initialize(token);
}

fn gen_address(address_felt: felt252) -> ContractAddress {
    address_felt.try_into().unwrap()
}
