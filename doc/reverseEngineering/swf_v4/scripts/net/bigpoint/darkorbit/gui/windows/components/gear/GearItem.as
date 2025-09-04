package net.bigpoint.darkorbit.gui.windows.components.gear
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   
   public class GearItem extends Sprite
   {
      
      public static const MOUSE_OVER:String = "MOUSE_OVER";
      
      public static const MOUSE_OUT:String = "MOUSE_OUT";
      
      public static const CLICKED:String = "CLICKED";
      
      public static const ITEM_HEIGHT:int = 22;
      
      private static const ARROW_SIZE:int = 8;
      
      private var backgroundContainer:Sprite;
      
      private var activeContainer:Sprite;
      
      private var itemWidth:int;
      
      public var title:String;
      
      public var icon:Bitmap;
      
      public var gearID:int;
      
      public var submenuID:int = -1;
      
      private var subMenuArrow:Sprite;
      
      public function GearItem(param1:int, param2:String, param3:Bitmap, param4:int)
      {
         super();
         this.gearID = param1;
         this.title = param2;
         this.icon = param3;
         this.itemWidth = param4;
         this.init();
      }
      
      private function init() : void
      {
         this.useHandCursor = true;
         this.buttonMode = true;
         this.backgroundContainer = new Sprite();
         this.activeContainer = new Sprite();
         this.subMenuArrow = new Sprite();
         this.activeContainer.visible = false;
         this.backgroundContainer.addChild(this.activeContainer);
         this.addChild(this.backgroundContainer);
         this.addChild(this.subMenuArrow);
         this.icon.scaleX = this.icon.scaleY = ITEM_HEIGHT / this.icon.width;
         this.backgroundContainer.addChild(this.icon);
         this.backgroundContainer.addChild(this.getFormattedText());
         this.backgroundContainer.mouseEnabled = false;
         this.backgroundContainer.mouseChildren = false;
         this.drawButton(this.backgroundContainer,2236962);
         this.drawButton(this.activeContainer,6710886);
         this.addListeners();
      }
      
      public function addListeners() : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.addEventListener(MouseEvent.CLICK,this.handleClick);
      }
      
      public function removeListeners() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.removeEventListener(MouseEvent.CLICK,this.handleClick);
      }
      
      private function handleClick(param1:MouseEvent) : void
      {
         this.activeContainer.visible = false;
         dispatchEvent(new Event(CLICKED));
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this.activeContainer.visible = true;
         dispatchEvent(new Event(MOUSE_OVER));
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         this.activeContainer.visible = false;
         dispatchEvent(new Event(MOUSE_OUT));
      }
      
      private function getFormattedText() : TextField
      {
         var _loc1_:TextFormat = new TextFormat(Styles.plainBigFmt.font,11,16777215,false);
         var _loc2_:TextField = new TextField();
         _loc2_.antiAliasType = AntiAliasType.ADVANCED;
         _loc2_.embedFonts = true;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.selectable = false;
         _loc2_.defaultTextFormat = _loc1_;
         _loc2_.setTextFormat(_loc1_);
         _loc2_.x = 25;
         _loc2_.y = 3;
         _loc2_.text = this.title;
         if(_loc2_.width > this.itemWidth - _loc2_.x)
         {
            _loc2_.text = this.title.substr(0,15) + "...";
         }
         return _loc2_;
      }
      
      private function drawButton(param1:Sprite, param2:uint) : void
      {
         param1.graphics.clear();
         param1.graphics.beginFill(param2);
         param1.graphics.drawRect(1,0,this.itemWidth - 2,this.icon.height);
         param1.graphics.endFill();
         param1.graphics.lineStyle(0.1,6710886);
         param1.graphics.moveTo(0,0);
         param1.graphics.lineTo(0,this.icon.height);
         param1.graphics.moveTo(this.itemWidth - 2,0);
         param1.graphics.lineTo(this.itemWidth - 2,this.icon.height);
      }
      
      public function drawArrow() : void
      {
         this.subMenuArrow.x = this.itemWidth - ARROW_SIZE;
         this.subMenuArrow.y = (this.icon.height - ARROW_SIZE) * 0.5;
         this.subMenuArrow.graphics.beginFill(16777215);
         this.subMenuArrow.graphics.lineTo(0,ARROW_SIZE);
         this.subMenuArrow.graphics.lineTo(ARROW_SIZE * 0.5,ARROW_SIZE * 0.5);
         this.subMenuArrow.graphics.lineTo(0,0);
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
   }
}

