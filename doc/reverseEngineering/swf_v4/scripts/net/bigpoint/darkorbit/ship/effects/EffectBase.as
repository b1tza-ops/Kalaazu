package net.bigpoint.darkorbit.ship.effects
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.TweenClip;
   
   public class EffectBase extends TweenClip implements IEffect
   {
      
      public var id:int;
      
      public var pattern:EffectPattern;
      
      public var effectResource:Sprite;
      
      public var args:Array;
      
      private var loop:Boolean;
      
      public var containingMapObjectScale:Number;
      
      protected var effectMc:MovieClip;
      
      public var useBitmapClip:Boolean;
      
      public var associatedMapObject:MapObject;
      
      public var priority:int;
      
      public var performanceRating:Number;
      
      public function EffectBase(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         var _loc6_:AssetLazyLoader = null;
         super();
         this.loop = param5;
         this.args = param4;
         this.id = param1;
         this.pattern = param2;
         this.useBitmapClip = param3;
         this.effectResource = new Sprite();
         if(param2.resKey != "")
         {
            _loc6_ = new AssetLazyLoader();
            _loc6_.addEventListener(AssetLazyLoader.ASSET_LOADED,this.resourceLoadedHandler);
            _loc6_.loadAsset(param2.resKey);
         }
         else
         {
            this.initEffectVisuals();
         }
      }
      
      public function resourceLoadedHandler(param1:Event) : void
      {
         var _loc5_:BitmapClip = null;
         var _loc2_:AssetLazyLoader = AssetLazyLoader(param1.target);
         _loc2_.removeEventListener(AssetLazyLoader.ASSET_LOADED,this.resourceLoadedHandler);
         var _loc3_:String = AssetLazyLoader(param1.target).resKeyForThisLoader;
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc3_));
         this.effectMc = _loc4_.getEmbededMovieClip("mc");
         if(this.useBitmapClip)
         {
            _loc5_ = new BitmapClip(this.effectMc,_loc3_);
            this.effectResource.addChild(_loc5_);
         }
         else
         {
            this.effectResource.addChild(this.effectMc);
         }
         this.setClip(this.effectResource.getChildAt(0),false);
         this.initEffectVisuals();
      }
      
      public function initEffectVisuals() : void
      {
      }
      
      public function getEffect() : Sprite
      {
         return this.effectResource;
      }
      
      public function start() : void
      {
         var _loc1_:AssetLazyLoader = null;
         if(this.clip != null)
         {
            this.playAnimation();
         }
         else
         {
            _loc1_ = new AssetLazyLoader();
            _loc1_.addEventListener(AssetLazyLoader.ASSET_LOADED,this.handlePlayOnLoaded);
            _loc1_.loadAsset(this.pattern.resKey);
         }
      }
      
      private function handlePlayOnLoaded(param1:Event) : void
      {
         this.playAnimation();
      }
      
      public function stop() : void
      {
         this.stopAnimation();
      }
      
      public function resizeMC(param1:Number) : void
      {
         this.clip.scaleX = param1;
         this.clip.scaleY = param1;
      }
      
      public function cleanup() : void
      {
      }
      
      public function update(param1:Main, param2:Array) : void
      {
      }
   }
}

