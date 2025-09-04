package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class MapDiverseCondition extends Condition
   {
      
      private var _map_name_list:String;
      
      private var _map_ids:Array;
      
      public function MapDiverseCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         this._map_ids = [];
         this._map_name_list = "";
         var _loc2_:Array = InGameCatalog.instance.mapNames;
         var _loc3_:Array = param1.split(",");
         var _loc4_:int = parseInt(_loc3_.shift());
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            this._map_ids[_loc5_] = parseInt(_loc3_[_loc5_]);
            if(_loc2_[this._map_ids[_loc5_]] != null)
            {
               this._map_name_list += ", " + _loc2_[this._map_ids[_loc5_]];
            }
            _loc5_++;
         }
         this._map_name_list = this._map_name_list.substring(2);
         _description = _description.replace(/%maps%/,this._map_name_list);
      }
   }
}

