#[contract]
mod Lending {

    #[external]
    fn add(a: felt252, b: felt252) -> felt252 {
        a + b
    }

}
