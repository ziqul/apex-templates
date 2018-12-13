@isTest
private class Repa_Test {

    @isTest
    private static void positive_AllOperations() {
        Repa.Repository repo = new Repa.Repository();

        Account a = new Account(
            Name = 'Test Account'
        );

        repo.create(a);
        repo.modify(a);
        repo.remove(a);
        repo.find('SELECT Id FROM Account');
    }
}
