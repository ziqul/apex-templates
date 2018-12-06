@isTest
private class TrigMan_Test {

    @isTest
    private static void positive_manage_BeforeInsert() {
        TrigMan.TriggerHandler handler =
            new TriggerHandlerStub();

        TrigMan.TriggerHandlersProvider provider =
            new TriggerHandlersProviderMock(
                TrigMan.Moment.BEFORE,
                TrigMan.Operation.INSERTX,
                handler);

        TrigMan.TriggerManager manager = new TrigMan.TriggerManager(provider);
        manager.currentMoment = TrigMan.Moment.BEFORE;
        manager.currentOperation = TrigMan.Operation.INSERTX;

        Test.startTest();

            manager.manage();

        Test.stopTest();

        System.assert(((TriggerHandlerStub) handler).wasCalled);
    }

    @isTest
    private static void positive_manage_AfterInsert() {
        TrigMan.TriggerHandler handler =
            new TriggerHandlerStub();

        TrigMan.TriggerHandlersProvider provider =
            new TriggerHandlersProviderMock(
                TrigMan.Moment.AFTER,
                TrigMan.Operation.INSERTX,
                handler);

        TrigMan.TriggerManager manager = new TrigMan.TriggerManager(provider);
        manager.currentMoment = TrigMan.Moment.BEFORE;
        manager.currentOperation = TrigMan.Operation.INSERTX;

        Test.startTest();

            manager.manage();

        Test.stopTest();

        System.assert(!((TriggerHandlerStub) handler).wasCalled);
    }

    @isTest
    private static void positive_manage_BeforeUpdate() {
        TrigMan.TriggerHandler handler =
            new TriggerHandlerStub();

        TrigMan.TriggerHandlersProvider provider =
            new TriggerHandlersProviderMock(
                TrigMan.Moment.BEFORE,
                TrigMan.Operation.UPDATEX,
                handler);

        TrigMan.TriggerManager manager = new TrigMan.TriggerManager(provider);
        manager.currentMoment = TrigMan.Moment.BEFORE;
        manager.currentOperation = TrigMan.Operation.INSERTX;

        Test.startTest();

            manager.manage();

        Test.stopTest();

        System.assert(!((TriggerHandlerStub) handler).wasCalled);
    }

    @isTest
    private static void positive_manage_CalledNotFromTest() {
        TrigMan.TriggerHandler handler =
            new TriggerHandlerStub();

        TrigMan.TriggerHandlersProvider provider =
            new TriggerHandlersProviderMock(
                TrigMan.Moment.BEFORE,
                TrigMan.Operation.UPDATEX,
                handler);

        TrigMan.TriggerManager manager = new TrigMan.TriggerManager(provider);

        Test.startTest();

            manager.manage();

        Test.stopTest();

        System.assert(!((TriggerHandlerStub) handler).wasCalled);
    }

    @isTest
    private static void negative_TriggerHandlerStructureConstruct_MomentIsNull() {
        TrigMan.TriggerHandler handler =
            new TriggerHandlerStub();

        Exception caughtException;

        Test.startTest();

            try {
                new TriggerHandlersProviderMock(
                    null,
                    TrigMan.Operation.INSERTX,
                    handler).getHandlers();
            } catch (InvalidParameterValueException ipve) {
                caughtException = ipve;
            }

        Test.stopTest();

        System.assertNotEquals(caughtException, null);
        System.assert(!((TriggerHandlerStub) handler).wasCalled);
    }

    @isTest
    private static void negative_TriggerHandlerStructureConstruct_OperationIsNull() {
        TrigMan.TriggerHandler handler =
            new TriggerHandlerStub();

        Exception caughtException;

        Test.startTest();

            try {
                new TriggerHandlersProviderMock(
                    TrigMan.Moment.BEFORE,
                    null,
                    handler).getHandlers();
            } catch (InvalidParameterValueException ipve) {
                caughtException = ipve;
            }

        Test.stopTest();

        System.assertNotEquals(caughtException, null);
        System.assert(!((TriggerHandlerStub) handler).wasCalled);
    }

    @isTest
    private static void negative_TriggerHandlerStructureConstruct_HandlerIsNull() {
        Exception caughtException;

        Test.startTest();

            try {
                new TriggerHandlersProviderMock(
                    TrigMan.Moment.BEFORE,
                    TrigMan.Operation.INSERTX,
                    null).getHandlers();
            } catch (InvalidParameterValueException ipve) {
                caughtException = ipve;
            }

        Test.stopTest();

        System.assertNotEquals(caughtException, null);
    }

    private class TriggerHandlerStub
        implements
            TrigMan.TriggerHandler
    {
        private Boolean wasCalled = false;

        public void handle(
            List<SObject> newList, List<SObject> oldList,
            Map<Id, SObject> newMap, Map<Id, SObject> oldMap)
        {
            this.wasCalled = true;
        }
    }

    private class TriggerHandlersProviderMock
        implements
            TrigMan.TriggerHandlersProvider
    {
        private TrigMan.Moment moment;
        private TrigMan.Operation operation;
        private TrigMan.TriggerHandler handler;

        public TriggerHandlersProviderMock(
            TrigMan.Moment moment,
            TrigMan.Operation operation,
            TrigMan.TriggerHandler handler)
        {
            this.moment = moment;
            this.operation = operation;
            this.handler = handler;
        }

        public List<TrigMan.TriggerHandlerStructure> getHandlers() {
            return new List<TrigMan.TriggerHandlerStructure> {
                new TrigMan.TriggerHandlerStructure(
                    this.moment, this.operation, this.handler)
            };
        }
    }
}