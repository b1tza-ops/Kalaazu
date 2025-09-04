package net.bigpoint.darkorbit.gui.windows.components.gear
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.ResourceManager;
   
   public class GearScroller extends Sprite
   {
      
      private var comboboxBodyTop:Bitmap;
      
      private var comboboxBodyBottom:Bitmap;
      
      private var container:Sprite;
      
      private var items:Array = [];
      
      public var gearID:int;
      
      public function GearScroller(param1:int = -1)
      {
         super();
         this.gearID = param1;
         this.visible = false;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.comboboxBodyTop = _loc1_.getEmbededBitmap("top.png");
         this.comboboxBodyBottom = _loc1_.getEmbededBitmap("down.png");
         this.comboboxBodyBottom.x = -1;
         this.comboboxBodyTop.visible = false;
         this.comboboxBodyBottom.visible = false;
         this.container = new Sprite();
         this.container.y = this.comboboxBodyTop.height;
         this.addChild(this.comboboxBodyTop);
         this.addChild(this.comboboxBodyBottom);
         this.addChild(this.container);
      }
      
      public function addElement(param1:GearItem) : void
      {
         param1.submenuID = this.gearID;
         this.container.addChild(param1);
         this.items.push(param1);
         this.setPosition();
         this.comboboxBodyBottom.visible = true;
         this.comboboxBodyTop.visible = true;
      }
      
      private function setPosition() : void
      {
         var _loc2_:GearItem = null;
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.items.length)
         {
            _loc2_ = this.items[_loc3_];
            if(_loc2_ != null)
            {
               _loc2_.y = _loc1_;
               _loc1_ += _loc2_.height;
            }
            _loc3_++;
         }
         this.comboboxBodyBottom.y = _loc1_ + this.comboboxBodyTop.height;
      }
      
      public function removeElement(param1:GearItem) : void
      {
         var _loc2_:GearItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.items.length)
         {
            _loc2_ = this.items[_loc3_];
            if(_loc2_ != null && _loc2_.gearID == param1.gearID)
            {
               this.container.removeChild(_loc2_);
               this.items[_loc3_] = null;
            }
            _loc3_++;
         }
         this.setPosition();
      }
      
      public function removeAllElements() : void
      {
         while(this.container.numChildren > 0)
         {
            this.container.removeChildAt(this.container.numChildren - 1);
         }
         this.items = [];
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function toggleVisibility() : void
      {
         this.visible = !this.visible;
      }
      
      public function getElement(param1:int) : GearItem
      {
         return this.items[param1] as GearItem;
      }
      
      public function getElementByID(param1:int) : GearItem
      {
         var _loc2_:GearItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.items.length)
         {
            _loc2_ = this.items[_loc3_] as GearItem;
            if(_loc2_ != null && _loc2_.gearID == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

