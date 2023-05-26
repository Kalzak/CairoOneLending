use src::Lending;

#[test]
#[available_gas(2000000)]
fn add() {
    assert(Lending::add(2,3) == 5, 'add error');
}
