package net.bigpoint.darkorbit.tdm
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   
   public class TDMCounter extends MovieClip
   {
      
      private var tdmManager:TDMManager;
      
      private var centerBitmap:Bitmap;
      
      private var displayOnList:Array = [];
      
      private var _lightsOff:int = 10;
      
      public function TDMCounter(param1:TDMManager)
      {
         super();
         this.tdmManager = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc5_:Bitmap = null;
         var _loc6_:Bitmap = null;
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.alpha = 0;
         this.centerBitmap = _loc1_.getEmbededBitmap("tdm_counter");
         this.addChild(this.centerBitmap);
         this.x = ScreenManager.getHalfScreenWidth() - this.centerBitmap.width / 2;
         this.y = ScreenManager.getHalfScreenHeight() - this.centerBitmap.height;
         var _loc2_:Sprite = new Sprite();
         var _loc3_:int = 21;
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            _loc5_ = _loc1_.getEmbededBitmap("center_display_off");
            _loc2_.addChild(_loc5_);
            _loc5_.y = _loc4_ * _loc3_;
            _loc6_ = _loc1_.getEmbededBitmap("center_display_on");
            _loc6_.visible = false;
            _loc2_.addChild(_loc6_);
            _loc6_.y = _loc4_ * _loc3_;
            this.displayOnList.push(_loc6_);
            _loc4_++;
         }
         _loc2_.x = 12;
         _loc2_.y = 2;
         this.addChild(_loc2_);
      }
      
      public function startCounter(param1:int) : void
      {
         if(this.lightsOff == 10)
         {
            TweenLite.to(this,param1,{
               "ease":Linear.easeNone,
               "lightsOff":0,
               "onUpdate":this.onUpdate
            });
         }
      }
      
      private function onUpdate() : void
      {
         var _loc1_:Bitmap = this.displayOnList[this.lightsOff];
         if(!_loc1_.visible)
         {
            if(this.lightsOff == 0)
            {
               AudioManager.playSoundEffect(28);
               this.tdmManager.removeIntro();
            }
            else
            {
               AudioManager.playSoundEffect(27);
            }
         }
         _loc1_.visible = true;
      }
      
      public function get lightsOff() : int
      {
         return this._lightsOff;
      }
      
      public function set lightsOff(param1:int) : void
      {
         this._lightsOff = param1;
      }
   }
}

