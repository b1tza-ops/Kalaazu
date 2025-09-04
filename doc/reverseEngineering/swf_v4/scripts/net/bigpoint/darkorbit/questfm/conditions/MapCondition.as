package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class MapCondition extends Condition
   {
      
      private var _map_id:int;
      
      public function MapCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         this._map_id = parseInt(param1);
         _description = _description.replace(/%map%/,InGameCatalog.instance.mapNames[this._map_id]);
      }
   }
}

