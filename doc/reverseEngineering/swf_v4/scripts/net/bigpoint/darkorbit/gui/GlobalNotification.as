package net.bigpoint.darkorbit.gui
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.Styles;
   
   public class GlobalNotification extends Sprite
   {
      
      public static const HANDLE_FADEOUT_COMPLETE:String = "handleFadeOutComplete";
      
      private static const mediumGlowFilter:GlowFilter = new GlowFilter(0,1,4,4,6,1);
      
      private var _displayTime:int;
      
      public function GlobalNotification(param1:String, param2:int, param3:int = 2)
      {
         var _loc6_:BitmapData = null;
         super();
         this._displayTime = param3;
         var _loc4_:TextField = new TextField();
         var _loc5_:TextFormat = new TextFormat(Styles.h1Fmt.font,28);
         _loc5_.align = TextFormatAlign.CENTER;
         _loc5_.color = 15327936;
         _loc4_.defaultTextFormat = _loc5_;
         _loc4_.embedFonts = Styles.h1Embed;
         _loc4_.text = param1;
         _loc4_.width = param2;
         _loc4_.wordWrap = true;
         _loc4_.filters = [mediumGlowFilter];
         _loc4_.autoSize = TextFieldAutoSize.CENTER;
         var _loc7_:int = _loc4_.width;
         _loc6_ = new BitmapData(_loc7_,_loc4_.height + 3,true,0);
         var _loc8_:Matrix = new Matrix();
         _loc6_.draw(_loc4_,_loc8_);
         addChild(new Bitmap(_loc6_));
         alpha = 0;
      }
      
      public function dispose() : void
      {
         this.removeFromParent();
      }
      
      public function removeFromParent() : void
      {
         if(parent != null && parent.contains(this))
         {
            parent.removeChild(this);
         }
      }
      
      public function moveTo(param1:int) : void
      {
         if(param1 == y)
         {
            return;
         }
         TweenLite.to(this,0.4,{
            "y":param1,
            "ease":Quad.easeOut
         });
      }
      
      private function startFadeOut() : void
      {
         TweenLite.to(this,0.3,{
            "alpha":0,
            "ease":Quad.easeOut,
            "onComplete":this.handleFadeOutComplete
         });
      }
      
      public function startFadeIn() : void
      {
         alpha = 0;
         TweenLite.to(this,0.1,{"alpha":1});
      }
      
      public function show() : void
      {
         this.startFadeIn();
         TweenMax.delayedCall(this._displayTime - 1,this.startFadeOut);
      }
      
      private function handleFadeOutComplete() : void
      {
         this.removeFromParent();
         dispatchEvent(new Event(HANDLE_FADEOUT_COMPLETE));
      }
   }
}

