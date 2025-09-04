package net.bigpoint.darkorbit.ship
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.net.models.skills.SkillDesignAbilities;
   
   public class ShipSkillDecorator extends Sprite
   {
      
      private static const logger:ILogger = Log.getLogger("ShipSkillDecorator");
      
      private var skillClips:Dictionary = new Dictionary();
      
      private var playAfterLoading:Boolean = false;
      
      private var ship:MapObject;
      
      private const NUMBER_OF_LIGHT_FLASHES_SOLACE:int = 11;
      
      public function ShipSkillDecorator(param1:MapObject)
      {
         super();
         this.ship = param1;
      }
      
      private function addSkillMc(param1:String) : void
      {
         var _loc2_:SkillClip = null;
         if(!this.isSkillLoaded(param1))
         {
            _loc2_ = new SkillClip();
            this.skillClips[param1] = _loc2_;
            _loc2_.setClip(ResourceManager.getMovieClip(param1,"mc"));
            this.resizeMC(_loc2_);
            this.addChild(_loc2_);
         }
      }
      
      private function resizeMC(param1:SkillClip) : void
      {
         var _loc2_:MovieClip = MovieClip(this.ship.shipContainer.getChildAt(0));
         var _loc3_:Number = Math.max(_loc2_.height,_loc2_.width) * 0.5 / 65;
         param1.setScale(_loc3_);
      }
      
      public function setClip(param1:String) : void
      {
         var _loc2_:AssetLazyLoader = new AssetLazyLoader();
         _loc2_.addEventListener(AssetLazyLoader.ASSET_LOADED,this.handleAssetLoaded);
         _loc2_.loadAsset(param1);
      }
      
      private function handleAssetLoaded(param1:Event) : void
      {
         var _loc2_:AssetLazyLoader = AssetLazyLoader(param1.target);
         _loc2_.removeEventListener(AssetLazyLoader.ASSET_LOADED,this.handleAssetLoaded);
         var _loc3_:String = AssetLazyLoader(param1.target).resKeyForThisLoader;
         this.addSkillMc(_loc3_);
         if(this.playAfterLoading)
         {
            this.playAfterLoading = false;
            this.playAnimation(AssetLazyLoader(param1.target).resKeyForThisLoader);
         }
      }
      
      public function isSkillLoaded(param1:String) : Boolean
      {
         return this.skillClips[param1] != null;
      }
      
      public function playAnimation(param1:String) : void
      {
         if(this.isSkillLoaded(param1))
         {
            if(param1 != SkillDesignAbilities.SHIP_INSTANT_HEAL_NAME)
            {
               SkillClip(this.skillClips[param1]).playAnimation(true);
            }
            else
            {
               SkillClip(this.skillClips[param1]).playInstantAnimation();
               if(this.ship.shipLightDecorator.numberOfFlashes < 0)
               {
                  this.ship.shipLightDecorator.startFlashes(this.NUMBER_OF_LIGHT_FLASHES_SOLACE);
               }
            }
         }
         else
         {
            this.playAfterLoading = true;
            this.setClip(param1);
         }
      }
      
      public function stopAnimation(param1:String) : void
      {
         if(this.isSkillLoaded(param1))
         {
            SkillClip(this.skillClips[param1]).stopAnimation();
         }
      }
   }
}

