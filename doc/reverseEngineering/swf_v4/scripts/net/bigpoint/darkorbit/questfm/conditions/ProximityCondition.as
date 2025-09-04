package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class ProximityCondition extends Condition
   {
      
      private var _avatar_id:int;
      
      private var _npc_id:int;
      
      private var _radius:int;
      
      public function ProximityCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         var _loc2_:Array = param1.split(",");
         this._avatar_id = parseInt(_loc2_.shift());
         this._npc_id = parseInt(_loc2_.shift());
         this._radius = parseInt(_loc2_.shift());
         _description = _description.replace(/%opponent%/,InGameCatalog.instance.npc_names[this._npc_id]);
         _helpIconsClipIds = [InGameCatalog.instance.npc_icons[this._npc_id] + "_icon.png"];
      }
   }
}

