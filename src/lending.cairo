#[contract]
mod Lending {

    use starknet::ContractAddress;    
    use starknet::contract_address_const; // TODO ContractAddressZeroable

    use starknet::get_caller_address;
    use starknet::get_contract_address;

    use src::interfaces::IERC20;
    use src::interfaces::IERC20::IERC20Dispatcher;
    use src::interfaces::IERC20::IERC20DispatcherTrait;

    struct Storage {
        // The collateral and borrow asset
        asset_token: ContractAddress,

        // The available collateral for each borrower
        available_collateral: LegacyMap::<ContractAddress, u256>,

        // The amount of liquidity available to borrow
        available_liquidity: u256,

        // The amount of liquidity deposited per address
        deposited_liquidity: LegacyMap::<ContractAddress, u256>,
    }

    /////////////////////////////////////////////////////////////////////////
    // INITIALIZE
    /////////////////////////////////////////////////////////////////////////

    #[external]
    fn initialize(_asset_token: ContractAddress) {
        let uninitialized: bool = asset_token::read() == contract_address_const::<0>(); // TODO ContractAddressZeroable
        assert(uninitialized, 'Already initialized');

        asset_token::write(_asset_token);
    }

    /////////////////////////////////////////////////////////////////////////
    // USER FUNCTIONS
    /////////////////////////////////////////////////////////////////////////

    #[external]
    fn deposit_collateral(amount: u256) {
        asset_transfer_from(caller(), this(), amount);
        increase_collateral(caller(), amount);
    }

    #[external]
    fn withdraw_collateral(amount: u256) {
        asset_transfer_from(this(), caller(), amount);
        decrease_collateral(caller(), amount);
    }

    #[external]
    fn deposit_liquidity(amount: u256) {
        asset_transfer_from(caller(), this(), amount);
        increase_deposited_liquidity(caller(), amount);

        let current_available_liquidity = available_liquidity::read();
        available_liquidity::write(current_available_liquidity + amount);
    }

    #[external]
    fn withdraw_liquidity(amount: u256) {
        decrease_deposited_liquidity(caller(), amount);
        asset_transfer_from(this(), caller(), amount);

        let current_available_liquidity = available_liquidity::read();
        available_liquidity::write(current_available_liquidity - amount);
    }

    #[external]
    fn borrow(amount: u256)

    /////////////////////////////////////////////////////////////////////////
    // INTERNALS
    /////////////////////////////////////////////////////////////////////////

    fn increase_collateral(address: ContractAddress, amount: u256) {
        let current_collateral = available_collateral::read(address);
        available_collateral::write(address, current_collateral + amount)
    }

    fn decrease_collateral(address: ContractAddress, amount: u256) {
        let current_collateral = available_collateral::read(address);
        available_collateral::write(address, current_collateral - amount)
    }

    fn increase_deposited_liquidity(address: ContractAddress, amount: u256) {
        let current_user_liquidity = deposited_liquidity::read(address);
        deposited_liquidity::write(address, current_user_liquidity + amount)
    }

    fn decrease_deposited_liquidity(address: ContractAddress, amount: u256) {
        let current_user_liquidity = deposited_liquidity::read(address);
        deposited_liquidity::write(address, current_user_liquidity - amount)
    }

    fn asset_transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) {
        IERC20Dispatcher{contract_address: asset_token::read()}.transfer_from(sender, recipient, amount);
    }

    fn caller() -> ContractAddress {
        get_caller_address()
    }

    fn this() -> ContractAddress {
        get_contract_address()
    }

    /////////////////////////////////////////////////////////////////////////
    // GETTERS
    /////////////////////////////////////////////////////////////////////////

    #[view]
    fn get_asset_token() -> ContractAddress {
        asset_token::read()
    }
}
