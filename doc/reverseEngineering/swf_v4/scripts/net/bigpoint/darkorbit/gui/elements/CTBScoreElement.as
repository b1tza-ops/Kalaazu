package net.bigpoint.darkorbit.gui.elements
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.CTBBeacon;
   
   public class CTBScoreElement extends ScoreElement
   {
      
      private var rows:Array = [];
      
      public var _order:int;
      
      private var sortArray:Array = [];
      
      public function CTBScoreElement(param1:GuiManager, param2:int)
      {
         super(TYPE_CTB_SCORE,param1,param2);
         this.sortArray[1] = [1,2,3,2,1,3,3,1,2];
         this.sortArray[2] = [1,2,3,2,1,3,3,2,1];
         this.sortArray[3] = [1,3,2,2,3,1,3,1,2];
      }
      
      public function updateBeacon(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:CTBBeacon = this.getBeacon(param1);
         if(_loc4_ == null)
         {
            _loc4_ = new CTBBeacon(this,param1,param2);
            this.rows.push(_loc4_);
            this.sortRows();
         }
         _loc4_.update(param3);
      }
      
      private function sortRows() : void
      {
         var _loc3_:int = 0;
         var _loc4_:CTBBeacon = null;
         var _loc5_:CTBBeacon = null;
         var _loc1_:Array = this.sortArray[String(Hero.factionID)];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = int(_loc1_[_loc2_]);
            if(_loc3_ == companyID)
            {
               _loc4_ = this.getBeaconByCompanyID(_loc1_[_loc2_ + 1]);
               if(_loc4_ != null)
               {
                  _loc4_.y = 11;
                  if(companyID != Hero.factionID)
                  {
                     _loc4_.setHighlight();
                  }
               }
               _loc5_ = this.getBeaconByCompanyID(_loc1_[_loc2_ + 2]);
               if(_loc5_ != null)
               {
                  _loc5_.y = 22;
               }
            }
            _loc2_ += 3;
         }
      }
      
      private function getBeacon(param1:int) : CTBBeacon
      {
         var _loc3_:CTBBeacon = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.rows.length)
         {
            _loc3_ = this.rows[_loc2_];
            if(param1 == _loc3_.getID())
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function getBeaconByCompanyID(param1:int) : CTBBeacon
      {
         var _loc3_:CTBBeacon = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.rows.length)
         {
            _loc3_ = this.rows[_loc2_];
            if(param1 == _loc3_.companyID)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function get order() : int
      {
         return this._order;
      }
      
      public function set order(param1:int) : void
      {
         this._order = param1;
      }
   }
}

