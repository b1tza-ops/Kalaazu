package net.bigpoint.darkorbit.gui.windows.components
{
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   
   public class BarComponent extends Sprite
   {
      
      private static const GAP:int = 2;
      
      private var backGroundContainer:Sprite;
      
      private var barContainer:Sprite;
      
      private var iconContainer:Sprite;
      
      private var barColor:uint;
      
      private var totalbarWidth:int = 70;
      
      private var totalbarHeight:int = 6;
      
      private var currenBarWidth:int = 0;
      
      private var currentAmount:int = 0;
      
      private var maxAmount:int = 0;
      
      private var icon:Bitmap;
      
      private var overlayContainer:Sprite;
      
      private var textContainer:Sprite;
      
      private var barValue:TextField;
      
      public function BarComponent(param1:uint, param2:Bitmap = null)
      {
         super();
         this.icon = param2;
         this.barColor = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 5;
         this.backGroundContainer = new Sprite();
         this.barContainer = new Sprite();
         this.iconContainer = new Sprite();
         this.iconContainer.useHandCursor = true;
         this.iconContainer.buttonMode = true;
         this.textContainer = new Sprite();
         this.overlayContainer = new Sprite();
         if(this.icon != null)
         {
            this.iconContainer.addChild(this.icon);
            _loc1_ = this.iconContainer.width + _loc2_;
         }
         this.backGroundContainer.x = _loc1_;
         this.backGroundContainer.y = this.iconContainer.height * 0.5;
         this.backGroundContainer.addChild(this.barContainer);
         this.overlayContainer.graphics.beginFill(0,0);
         this.overlayContainer.graphics.drawRect(_loc1_,0,this.totalbarWidth,this.totalbarHeight * 4);
         this.overlayContainer.graphics.endFill();
         this.overlayContainer.addEventListener(MouseEvent.CLICK,this.handleOverlayClick);
         this.overlayContainer.useHandCursor = true;
         this.overlayContainer.buttonMode = true;
         var _loc3_:TextFormat = new TextFormat(Styles.plainBigFmt.font,10,16777215,false);
         this.barValue = new TextField();
         this.barValue.antiAliasType = AntiAliasType.ADVANCED;
         this.barValue.embedFonts = true;
         this.barValue.autoSize = TextFieldAutoSize.LEFT;
         this.barValue.defaultTextFormat = _loc3_;
         this.barValue.setTextFormat(_loc3_);
         this.barValue.width = this.totalbarWidth;
         this.barValue.x = this.iconContainer.width + 2;
         this.barValue.y = 2;
         this.textContainer.addChild(this.barValue);
         this.textContainer.visible = false;
         this.addChild(this.textContainer);
         this.addChild(this.backGroundContainer);
         this.addChild(this.iconContainer);
         this.addChild(this.overlayContainer);
         this.update(0,100);
      }
      
      private function toggleTextVisibility() : void
      {
         var _loc1_:Boolean = this.backGroundContainer.visible;
         this.backGroundContainer.visible = !_loc1_;
         this.textContainer.visible = _loc1_;
         this.backGroundContainer.alpha = 0;
         this.textContainer.alpha = 0;
         TweenLite.to(this.backGroundContainer,0.5,{"alpha":int(this.backGroundContainer.visible)});
         TweenLite.to(this.textContainer,0.5,{"alpha":int(this.textContainer.visible)});
      }
      
      private function handleOverlayClick(param1:MouseEvent) : void
      {
         this.toggleTextVisibility();
      }
      
      private function updateComponent(param1:int) : void
      {
         this.backGroundContainer.graphics.clear();
         this.barContainer.graphics.clear();
         this.backGroundContainer.graphics.beginFill(0,1);
         this.backGroundContainer.graphics.drawRect(0,0,this.totalbarWidth,this.totalbarHeight);
         this.backGroundContainer.graphics.endFill();
         this.barContainer.graphics.beginFill(this.barColor,1);
         this.barContainer.graphics.drawRect(0,0,1,this.totalbarHeight - GAP * 2);
         this.barContainer.graphics.endFill();
         this.barContainer.x = this.barContainer.y = GAP;
         this.barValue.text = this.formatText();
         TweenLite.to(this.barContainer,0.5,{"width":param1});
      }
      
      private function formatText() : String
      {
         var _loc1_:* = BPLocale.roundInteger(this.currentAmount);
         var _loc2_:* = BPLocale.roundInteger(this.maxAmount);
         if(this.currentAmount > 99999 || this.maxAmount > 99999)
         {
            _loc2_ = BPLocale.roundInteger(this.maxAmount * 0.001) + " K";
            _loc1_ = BPLocale.roundInteger(this.currentAmount * 0.001) + " K";
         }
         return _loc1_ + "/" + _loc2_;
      }
      
      public function update(param1:int, param2:int) : void
      {
         if(param1 > param2)
         {
            param1 = param2;
         }
         this.currentAmount = param1;
         this.maxAmount = param2;
         this.currenBarWidth = (this.totalbarWidth - 2 * GAP) * param1 / param2;
         this.updateComponent(this.currenBarWidth);
      }
      
      public function setSize(param1:int, param2:int) : void
      {
         this.totalbarWidth = param1;
         this.totalbarHeight = param2;
         this.updateComponent(this.currenBarWidth);
      }
      
      public function setColor(param1:uint) : void
      {
         this.barColor = param1;
         this.updateComponent(this.currenBarWidth);
      }
   }
}

