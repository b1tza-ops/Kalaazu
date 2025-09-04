package net.bigpoint.darkorbit.menu
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.MovieClip;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   
   public class TechButtonDecorator
   {
      
      public static const logger:ILogger = Log.getLogger("TechButtonDecorator");
      
      private var iconContainer:MovieClip;
      
      private var firstDigit:MovieClip;
      
      private var secondDigit:MovieClip;
      
      private var singleDigit:MovieClip;
      
      private var doubleDigits:MovieClip;
      
      private var initComplete:Boolean = false;
      
      private var numberBg:MovieClip;
      
      public function TechButtonDecorator(param1:MovieClip, param2:int)
      {
         super();
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         this.singleDigit = _loc3_.getEmbededMovieClip("keyboardIconsBlack");
         this.singleDigit.cacheAsBitmap = true;
         this.doubleDigits = _loc3_.getEmbededMovieClip("keyboardIconsTwoDigits");
         this.doubleDigits.cacheAsBitmap = true;
         this.numberBg = _loc3_.getEmbededMovieClip("techDigitBg");
         this.singleDigit.x = param1.width * 0.5 - this.singleDigit.width * 0.5;
         this.singleDigit.y = this.singleDigit.height * 0.5;
         this.doubleDigits.x = param1.width * 0.5 - this.doubleDigits.width * 0.5;
         this.doubleDigits.y = this.doubleDigits.height * 0.5;
         this.numberBg.x = 1.5;
         this.numberBg.y = 1.5;
         this.numberBg.alpha = 0.7;
         this.iconContainer = param1;
         var _loc4_:Array = this.splitDigits(param2);
         if(_loc4_ != null)
         {
            if(_loc4_.length == 1)
            {
               this.iconContainer.addChild(this.numberBg);
               this.iconContainer.addChild(this.singleDigit);
               this.singleDigit.gotoAndStop(_loc4_[0]);
            }
            else if(_loc4_.length == 2)
            {
               this.iconContainer.addChild(this.numberBg);
               this.iconContainer.addChild(this.doubleDigits);
               this.doubleDigits.first.gotoAndStop(_loc4_[1]);
               this.doubleDigits.second.gotoAndStop(_loc4_[0]);
            }
         }
         this.initComplete = true;
      }
      
      public function updateDigits(param1:int) : void
      {
         if(!this.initComplete)
         {
            return;
         }
         var _loc2_:Array = this.splitDigits(param1);
         if(_loc2_ == null)
         {
            if(this.iconContainer.contains(this.singleDigit))
            {
               this.iconContainer.removeChild(this.singleDigit);
            }
            if(this.iconContainer.contains(this.doubleDigits))
            {
               this.iconContainer.removeChild(this.doubleDigits);
            }
            if(this.iconContainer.contains(this.numberBg))
            {
               this.iconContainer.removeChild(this.numberBg);
            }
            return;
         }
         if(_loc2_.length == 1)
         {
            if(!this.iconContainer.contains(this.numberBg))
            {
               this.iconContainer.addChild(this.numberBg);
            }
            if(!this.iconContainer.contains(this.singleDigit))
            {
               this.iconContainer.addChild(this.singleDigit);
            }
            this.singleDigit.gotoAndStop(_loc2_[0]);
            if(this.iconContainer.contains(this.doubleDigits))
            {
               this.iconContainer.removeChild(this.doubleDigits);
            }
         }
         else if(_loc2_.length == 2)
         {
            if(!this.iconContainer.contains(this.numberBg))
            {
               this.iconContainer.addChild(this.numberBg);
            }
            if(!this.iconContainer.contains(this.doubleDigits))
            {
               this.iconContainer.addChild(this.doubleDigits);
            }
            this.doubleDigits.first.gotoAndStop(_loc2_[1]);
            this.doubleDigits.second.gotoAndStop(_loc2_[0]);
            if(this.iconContainer.contains(this.singleDigit))
            {
               this.iconContainer.removeChild(this.singleDigit);
            }
         }
      }
      
      private function splitDigits(param1:int) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:String = String(param1);
         if(param1 <= 99)
         {
            if(_loc3_.length > 1)
            {
               _loc2_.push(this.setDigit(String(param1).substring(1,2)));
               _loc2_.push(this.setDigit(String(param1).substring(0,1)));
            }
            else if(_loc3_.length == 1)
            {
               if(this.setDigit(String(param1).substring(0,1)) == 10)
               {
                  return null;
               }
               _loc2_.push(this.setDigit(String(param1).substring(0,1)));
            }
         }
         else
         {
            _loc2_.push(11);
         }
         return _loc2_;
      }
      
      private function setDigit(param1:String) : int
      {
         if(int(param1) == 0)
         {
            return 10;
         }
         return int(param1);
      }
      
      private function createDigitMC(param1:int) : MovieClip
      {
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         var _loc3_:MovieClip = _loc2_.getEmbededMovieClip("keyboardIconsBlack");
         _loc3_.cacheAsBitmap = true;
         _loc3_.gotoAndStop(param1);
         _loc3_.y = _loc3_.height / 2;
         return _loc3_;
      }
   }
}

