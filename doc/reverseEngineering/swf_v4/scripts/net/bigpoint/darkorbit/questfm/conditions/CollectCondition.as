package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class CollectCondition extends Condition
   {
      
      private var oreID:int;
      
      public function CollectCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:String) : void
      {
         super.parseMatches(param1);
         if(_mandatory)
         {
            _target_plain = "/" + _target;
         }
         this.oreID = int(param1);
         _description = _description.replace(/%ore%/,InGameCatalog.instance.ore_names[this.oreID]);
         _helpIconsClipIds = ["ore_" + this.oreID + ".png"];
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

