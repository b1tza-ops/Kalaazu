package net.bigpoint.darkorbit.gui.container
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   
   public class SimpleContainer extends Sprite
   {
      
      public static var CLASS_MINIMAP:int = 2;
      
      public static var CLASS_DARKORBIT_LOGO:int = 3;
      
      public static var CONTAINER_CLASS_HERO_INFO_0:int = 5;
      
      public static var CONTAINER_CLASS_HERO_INFO_1:int = 14;
      
      public static var CONTAINER_CLASS_HERO_INFO_2:int = 1;
      
      public static var CONTAINER_CLASS_HERO_INFO_3:int = 4;
      
      public static var CONTAINER_CLASS_OPPONENT_INFO:int = 0;
      
      public static const CLASS_BUTTONS:int = 6;
      
      public static const CLASS_LOG:int = 8;
      
      public static const CLASS_LOGOUT_WINDOW:int = 9;
      
      public static const CLASS_TRADE_ORE:int = 10;
      
      public static const CLASS_TRADE_WEBLINKS1:int = 11;
      
      public static const CLASS_TRADE_WEBLINKS2:int = 12;
      
      public static const CLASS_MINIMAP_LABEL:int = 13;
      
      public static const CLASS_QUEST_TREE:int = 15;
      
      public static const CLASS_QUEST_PAGE_DOTS:int = 16;
      
      public static const CLASS_CONNECTION_LOST:int = 17;
      
      public static const CLASS_SPACEMAP:int = 18;
      
      public static const CLASS_HERO_DESTROYED:int = 19;
      
      public static const CLASS_CONNECTION:int = 20;
      
      public static const CLASS_BETA:int = 21;
      
      public static const CLASS_BOOSTER:int = 22;
      
      public static const CLASS_SPACEBALL:int = 23;
      
      public static const CLASS_INVASION:int = 24;
      
      public static const CLASS_CTB:int = 25;
      
      public static const CLASS_TDM:int = 26;
      
      public static const CLASS_CHAT:int = 27;
      
      public static const CLASS_PROMPT:int = 28;
      
      public static const CLASS_COMMAND_LINE_INTERFACE:int = 29;
      
      public static const CLASS_GROUP_SYSTEM:int = 30;
      
      public static const CLASS_REFINEMENT_UPDATE_SOURCE:int = 31;
      
      public static const CLASS_REFINEMENT_UPDATE_TARGET:int = 32;
      
      public static const CLASS_REFINEMENT_QUERY:int = 33;
      
      public static const CLASS_REFINEMENT_BUTTONS:int = 36;
      
      public static const CLASS_REFINEMENT_UPDATE_STATIC:int = 37;
      
      public static const CLASS_REFINEMENT_REFINEMENT_STATIC:int = 38;
      
      public static const CLASS_REFINEMENT_REFINEMENT_SOURCE:int = 39;
      
      public static const CLASS_REFINEMENT_REFINEMENT_BUTTONS:int = 40;
      
      public static const CLASS_REFINEMENT_REFINEMENT_TREE:int = 41;
      
      public static const CLASS_DEFAULT:int = 35;
      
      public static const CLASS_SETTING_TABS:int = 42;
      
      public static const CLASS_SETTING_BUTTONS:int = 43;
      
      public static const CLASS_SETTING_TABPAGE_GAMEPLAY:int = 44;
      
      public static const CLASS_SETTING_TABPAGE_DISPLAY:int = 45;
      
      public static const CLASS_SETTING_TABPAGE_SOUND:int = 46;
      
      public static const CLASS_AUTOSTART_WARNING:int = 47;
      
      public static const CLASS_REPAIR_SHIP:int = 48;
      
      public static const CLASS_SCROLLABLE:int = 49;
      
      public static const CLASS_TECHS:int = 50;
      
      public static const CLASS_RANKED_HUNT_EVENT:int = 51;
      
      public static const CLASS_RANKED_HUNT_EVENT_COL_2:int = 52;
      
      public static const CLASS_SPACEMAP_ADVANCED:int = 53;
      
      public static const CLASS_PET_WINDOW_CONTENT:int = 54;
      
      public static const CLASS_PET_WINDOW_BANNER:int = 55;
      
      public static const CLASS_SETTING_TABPAGE_INTERFACE:int = 56;
      
      public static var NO_ALIGN:int = 0;
      
      public static var ALIGN_VERTICAL:int = 1;
      
      public static var ALIGN_HORIZONTAL:int = 2;
      
      public static var ALIGN_VERTICAL_CENTER:int = 3;
      
      private var positions:Array = [];
      
      protected var elements:Array = [];
      
      protected var guiManager:GuiManager;
      
      private var displayDigits:Boolean;
      
      private var classID:int;
      
      public function SimpleContainer(param1:GuiManager, param2:int)
      {
         super();
         this.guiManager = param1;
         this.classID = param2;
         this.cacheAsBitmap = true;
      }
      
      public function getClassID() : int
      {
         return this.classID;
      }
      
      public function removeElement(param1:DisplayObject) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.elements.length)
         {
            _loc3_ = this.elements[_loc2_];
            if(_loc3_ == param1)
            {
               this.elements.splice(_loc2_,1);
               this.removeChild(param1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function addElement(param1:DisplayObject, param2:int = 0, param3:int = 5) : void
      {
         var _loc4_:DisplayObject = null;
         if(this.numChildren > 0)
         {
            _loc4_ = this.getChildAt(this.numChildren - 1);
            if(param2 == ALIGN_VERTICAL)
            {
               param1.x = _loc4_.x;
               param1.y = _loc4_.y + _loc4_.height + param3;
            }
            else if(param2 == ALIGN_HORIZONTAL)
            {
               param1.y = _loc4_.y;
               param1.x = _loc4_.x + _loc4_.width + param3;
            }
            else if(param2 == ALIGN_VERTICAL_CENTER)
            {
               param1.x = this.width / 2 - param1.width / 2;
               param1.y = _loc4_.y + _loc4_.height + param3;
            }
         }
         this.elements.push(param1);
         this.addChild(param1);
      }
      
      public function getAllElements() : Array
      {
         return this.elements;
      }
      
      public function removeAllElements() : void
      {
         this.elements = [];
      }
      
      public function getElement(param1:int) : SimpleElement
      {
         var _loc3_:SimpleElement = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.elements.length)
         {
            _loc3_ = this.elements[_loc2_];
            if(_loc3_.getID() == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getElementAt(param1:int) : SimpleElement
      {
         return this.elements[param1];
      }
      
      public function getElements(param1:int) : Array
      {
         var _loc4_:SimpleElement = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.elements.length)
         {
            _loc4_ = this.elements[_loc3_];
            if(_loc4_.getID() == param1)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function get width() : Number
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc1_:Number = super.width;
         var _loc2_:int = 0;
         while(_loc2_ < this.elements.length)
         {
            _loc3_ = this.elements[_loc2_];
            _loc4_ = this.recurseChildWidth(_loc3_);
            if(_loc4_ > _loc1_)
            {
               _loc1_ = _loc4_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function recurseChildWidth(param1:Object) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc2_:int = 0;
         if(param1 is Sprite)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.numChildren)
            {
               _loc4_ = param1.getChildAt(_loc3_);
               if(_loc4_ is Sprite)
               {
                  if(_loc4_.width > _loc2_)
                  {
                     _loc2_ = int(_loc4_.width);
                  }
                  _loc5_ = this.recurseChildWidth(_loc4_);
                  if(_loc5_ > _loc2_)
                  {
                     _loc2_ = _loc5_;
                  }
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      override public function get height() : Number
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc1_:Number = super.height;
         var _loc2_:int = 0;
         while(_loc2_ < this.elements.length)
         {
            _loc3_ = this.elements[_loc2_];
            _loc4_ = this.recurseChildHeight(_loc3_);
            if(_loc4_ > _loc1_)
            {
               _loc1_ = _loc4_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function recurseChildHeight(param1:Object) : Number
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is Sprite)
            {
               if(_loc4_.height > _loc2_)
               {
                  _loc2_ = int(_loc4_.height);
               }
               _loc5_ = this.recurseChildHeight(_loc4_);
               if(_loc5_ > _loc2_)
               {
                  _loc2_ = _loc5_;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getParent() : DisplayObject
      {
         return this.parent;
      }
      
      public function setPredefinedPosition() : void
      {
         var _loc1_:Point = this.positions[0];
         if(this.isDisplayDigits())
         {
            if(this.positions[1] != null)
            {
               _loc1_ = this.positions[1];
            }
         }
         if(_loc1_ == null)
         {
            this.addPredefinedPosition(new Point(10,25));
            _loc1_ = this.positions[0];
         }
         this.x = _loc1_.x;
         this.y = _loc1_.y;
      }
      
      public function addPredefinedPosition(param1:Point) : void
      {
         this.positions.push(param1);
      }
      
      public function isDisplayDigits() : Boolean
      {
         return this.displayDigits;
      }
      
      public function setDisplayDigits(param1:Boolean) : void
      {
         this.displayDigits = param1;
      }
   }
}

