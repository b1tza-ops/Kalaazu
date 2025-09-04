package net.bigpoint.darkorbit.ship.effects
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class LocatorGearEffect extends EffectBase
   {
      
      public function LocatorGearEffect(param1:int, param2:EffectPattern, param3:Boolean = false, param4:Array = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function initEffectVisuals() : void
      {
         this.playInstantAnimation(1,true,false,1);
         var _loc1_:Bitmap = args[1] as Bitmap;
         var _loc2_:Sprite = new Sprite();
         var _loc3_:MovieClip = SWFFinisher(ResourceManager.fileCollection.getFinisher("locator")).getEmbededMovieClip("iconframe");
         _loc1_.x = -_loc1_.width * 0.5;
         _loc1_.y = -_loc1_.height * 0.5;
         _loc2_.y = -110;
         _loc2_.addChild(_loc3_);
         _loc2_.addChild(_loc1_);
         getEffect().addChild(_loc2_);
      }
      
      override public function update(param1:Main, param2:Array) : void
      {
         var _loc8_:int = 0;
         var _loc3_:int = int(param2[0]);
         var _loc4_:int = int(param2[1]);
         var _loc5_:int = param1.screenManager.map.getShipManager().getHero().x;
         var _loc6_:int = param1.screenManager.map.getShipManager().getHero().y;
         var _loc7_:Sprite = getEffect();
         var _loc9_:Number = 0.2;
         if(_loc3_ == -1 && _loc4_ == -1)
         {
            if(_loc7_.filters.length == 0)
            {
               _loc7_.alpha = _loc9_;
            }
         }
         else
         {
            _loc7_.alpha = 1;
            _loc8_ = Math.round(Math.atan2(_loc4_ - _loc6_,_loc3_ - _loc5_) * 180 / Math.PI) + 90;
            if(_loc8_ != Math.round(_loc7_.rotation) && _loc8_ != 360 + Math.round(_loc7_.rotation))
            {
               TweenLite.to(_loc7_,1,{
                  "rotation":_loc8_,
                  "ease":Strong.easeOut
               });
               if(_loc7_.numChildren > 0)
               {
                  TweenLite.to(_loc7_.getChildAt(1),1,{
                     "rotation":-_loc8_,
                     "ease":Strong.easeOut
                  });
               }
            }
         }
      }
   }
}

