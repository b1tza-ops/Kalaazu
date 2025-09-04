package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.menu.SuperActionButton;
   
   public class BitmapFont extends Bitmap
   {
      
      private var actionButton:SuperActionButton;
      
      private var source:BitmapData;
      
      private var rect:Rectangle;
      
      private var destinationPoint:Point;
      
      public function BitmapFont(param1:SuperActionButton)
      {
         super();
         this.actionButton = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         this.source = _loc1_.getEmbededBitmapData("bitmapFont");
         this.rect = new Rectangle();
         this.rect.width = 4;
         this.rect.height = 5;
         this.destinationPoint = new Point();
      }
      
      public function setText(param1:String) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = param1.split("");
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = int(_loc3_[_loc4_]);
            if(_loc5_ == 1)
            {
               _loc2_ += 2;
            }
            else
            {
               _loc2_ += 3;
            }
            if(_loc4_ < _loc3_.length - 1)
            {
               _loc2_ += 1;
            }
            _loc4_++;
         }
         this.bitmapData = new BitmapData(_loc2_,5,true,0);
         this.destinationPoint.x = _loc2_;
         var _loc6_:int = -1;
         _loc4_ = int(_loc3_.length - 1);
         while(_loc4_ > -1)
         {
            _loc5_ = int(_loc3_[_loc4_]);
            if(_loc6_ != -1 && _loc6_ == 1)
            {
               this.destinationPoint.x -= 3;
            }
            else
            {
               this.destinationPoint.x -= 4;
            }
            this.rect.x = _loc5_ * 4;
            bitmapData.copyPixels(this.source,this.rect,this.destinationPoint);
            _loc6_ = _loc5_;
            _loc4_--;
         }
         if(this.actionButton != null)
         {
            this.x = this.actionButton.getActionNormal().width / 2 - bitmapData.width / 2;
         }
      }
   }
}

