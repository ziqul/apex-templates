public class TrigMan {

    public enum Moment {
        BEFORE, AFTER
    }

    public enum Operation {
        INSERTX, UPDATEX, DELETEX, UNDELETEX
    }

    public interface TriggerHandler {
        void handle(
            List<SObject> newList, List<SObject> oldList,
            Map<Id, SObject> newMap, Map<Id, SObject> oldMap);
    }

    public interface TriggerHandlersProvider {
        List<TriggerHandlerStructure> getHandlers();
    }

    public class TriggerHandlerStructure {

        private Moment moment;
        private Operation operation;
        private TriggerHandler handler;

        public TriggerHandlerStructure(
            Moment moment,
            Operation operation,
            TriggerHandler handler)
        {
            if (moment == null) {
                throw new InvalidParameterValueException('moment', null);
            }

            if (operation == null) {
                throw new InvalidParameterValueException('operation', null);
            }

            if (handler == null) {
                throw new InvalidParameterValueException('handler', null);
            }

            this.moment = moment;
            this.operation = operation;
            this.handler = handler;
        }

        public Moment getMoment() {
            return this.moment;
        }

        public Operation getOperation() {
            return this.operation;
        }

        public TriggerHandler getHandler() {
            return this.handler;
        }
    }

    public class TriggerManager {

        private TriggerHandlersProvider provider;
        @testVisible
        private Moment currentMoment;
        @testVisible
        private Operation currentOperation;

        public TriggerManager(TriggerHandlersProvider provider) {
            this.provider = provider;
            this.currentMoment = this.getCurrentMoment();
            this.currentOperation = this.getCurrentOperation();
        }

        private Moment getCurrentMoment() {
            // Written in one line because of how Test Coverage work
            Moment currentMoment =
                !Trigger.isExecuting ?
                null : (Trigger.isBefore ? Moment.BEFORE : (Trigger.isAfter ? Moment.AFTER : null));

            return currentMoment;
        }

        private Operation getCurrentOperation() {
            // Written in one line because of how Test Coverage work
            Operation currentOperation =
                !Trigger.isExecuting ?
                null : (Trigger.isInsert ? Operation.INSERTX : (Trigger.isUpdate ? Operation.UPDATEX : (Trigger.isDelete ? Operation.DELETEX : (Trigger.isUndelete ? Operation.UNDELETEX : null))));

            return currentOperation;
        }

        public void manage() {
            if (this.currentMoment == null ||
                this.currentOperation == null)
            {
                return;
            }

            List<TriggerHandler> relevantHandlers = new List<TriggerHandler>();

            for (TriggerHandlerStructure hstruct_i : this.provider.getHandlers()) {
                if (hstruct_i.getMoment() == this.currentMoment &&
                    hstruct_i.getOperation() == this.currentOperation)
                {
                    relevantHandlers.add(hstruct_i.getHandler());
                }
            }

            for (TriggerHandler handler_i : relevantHandlers) {
                handler_i.handle(
                    Trigger.new, Trigger.old,
                    Trigger.newMap, Trigger.oldMap);
            }
        }
    }
}
