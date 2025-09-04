package net.bigpoint.darkorbit.ship.effects
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenMax;
   import fl.transitions.easing.None;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class CollectorBeamEffect extends EffectBase
   {
      
      private var spinningLoadAnimation:Bitmap;
      
      private var tween:TweenMax;
      
      private var countdownDuration:int;
      
      private var spinningHolster:Sprite;
      
      private var countdownText:TextField;
      
      private var useCountdownVisual:Boolean = false;
      
      public function CollectorBeamEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         var _loc1_:AssetLazyLoader = null;
         this.start();
         this.clip.y += 65;
         associatedMapObject = args[1];
         this.countdownDuration = args[0];
         this.useCountdownVisual = args[2];
         if(this.useCountdownVisual)
         {
            _loc1_ = new AssetLazyLoader();
            _loc1_.addEventListener(AssetLazyLoader.ASSET_LOADED,this.handleExtraAssetLoaded);
            _loc1_.loadAsset("ui");
         }
         this.addMapObjectMoveCheckTick();
      }
      
      private function handleExtraAssetLoaded(param1:Event) : void
      {
         var _loc2_:AssetLazyLoader = AssetLazyLoader(param1.target);
         _loc2_.removeEventListener(AssetLazyLoader.ASSET_LOADED,resourceLoadedHandler);
         var _loc3_:String = AssetLazyLoader(param1.target).resKeyForThisLoader;
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc3_));
         this.spinningLoadAnimation = _loc4_.getEmbededBitmap("loot_countdown_with_bg");
         this.spinningHolster = new Sprite();
         this.spinningHolster.addChild(this.spinningLoadAnimation);
         this.spinningLoadAnimation.x = -this.spinningLoadAnimation.width * 0.5;
         this.spinningLoadAnimation.y = -this.spinningLoadAnimation.height * 0.5;
         this.spinningHolster.y = this.clip.y + 55;
         this.countdownText = new TextField();
         this.countdownText.defaultTextFormat = Styles.h2Fmt;
         this.countdownText.setTextFormat(Styles.h2Fmt);
         this.countdownText.type = TextFieldType.DYNAMIC;
         this.countdownText.textColor = 15327936;
         this.countdownText.embedFonts = true;
         this.countdownText.autoSize = TextFieldAutoSize.CENTER;
         this.countdownText.antiAliasType = AntiAliasType.ADVANCED;
         this.countdownText.selectable = false;
         this.countdownText.width = 40;
         this.countdownText.x = this.spinningHolster.x - 2;
         this.countdownText.y = this.spinningHolster.y - 9;
         this.countdownText.text = "-";
         associatedMapObject.getClipContainer().addChild(this.spinningHolster);
         associatedMapObject.getClipContainer().addChild(this.countdownText);
         this.tween = TweenMax.to(this.spinningHolster,this.countdownDuration,{
            "ease":None.easeNone,
            "rotation":180 * this.countdownDuration,
            "onUpdate":this.setCountdownText,
            "onUpdateParams":[this.countdownText],
            "onComplete":this.handleLootCompleted
         });
      }
      
      private function setCountdownText(param1:TextField) : void
      {
         param1.text = (this.tween.duration - Math.round(this.tween.currentTime)).toString();
      }
      
      public function addMapObjectMoveCheckTick() : void
      {
         addEventListener(Event.ENTER_FRAME,this.mapObjectMoveCheck);
      }
      
      public function mapObjectMoveCheck(param1:Event) : void
      {
         if(associatedMapObject != null)
         {
            if(associatedMapObject.currentlyMoving)
            {
               this.actionOnMapObjectMove();
            }
         }
      }
      
      private function handleLootCompleted() : void
      {
         dispatchEvent(new EntityEffectEvent(EntityEffectEvent.EFFECT_TIMEOUT,id));
      }
      
      private function actionOnMapObjectMove() : void
      {
      }
      
      override public function cleanup() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.mapObjectMoveCheck);
         if(this.spinningHolster != null && associatedMapObject.getClipContainer().contains(this.spinningHolster))
         {
            associatedMapObject.getClipContainer().removeChild(this.spinningHolster);
         }
         if(this.countdownText != null && associatedMapObject.getClipContainer().contains(this.countdownText))
         {
            associatedMapObject.getClipContainer().removeChild(this.countdownText);
         }
         if(this.tween)
         {
            this.tween.kill();
            this.tween = null;
         }
         associatedMapObject = null;
      }
   }
}

