public class Repa {

    public virtual class Repository {

        public virtual List<SObject> create(List<SObject> newObjects) {
            insert newObjects;
            return newObjects;
        }

        public virtual SObject create(SObject newObject) {
            return this.create(new List<SObject> { newObject }).get(0);
        }

        public virtual List<SObject> modify(List<SObject> newObjects) {
            update newObjects;
            return newObjects;
        }

        public virtual SObject modify(SObject newObject) {
            return this.modify(new List<SObject> { newObject }).get(0);
        }

        public virtual void remove(List<SObject> newObjects) {
            delete newObjects;
        }

        public virtual void remove(SObject newObject) {
            this.remove(new List<SObject> { newObject });
        }

        public virtual List<SObject> find(String query) {
            return Database.query(query);
        }
    }
}
