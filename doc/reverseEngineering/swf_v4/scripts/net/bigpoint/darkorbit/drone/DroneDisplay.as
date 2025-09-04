package net.bigpoint.darkorbit.drone
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.ResourceManager;
   
   public class DroneDisplay extends BitmapData
   {
      
      private var point:Point;
      
      public function DroneDisplay(param1:int, param2:int)
      {
         super(80,12,true,0);
         this.point = new Point();
         this.update(param1,param2);
      }
      
      public function update(param1:int, param2:int) : void
      {
         var _loc6_:int = 0;
         var _loc3_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc4_:BitmapData = _loc3_.getEmbededBitmapData("drone_prefix");
         copyPixels(_loc4_,_loc4_.rect,this.point);
         var _loc5_:BitmapData = _loc3_.getEmbededBitmapData("iris_dot");
         this.point.x = 10;
         this.point.y = 0;
         _loc6_ = 0;
         while(_loc6_ < param2)
         {
            this.copyPixels(_loc5_,_loc5_.rect,this.point);
            this.point.x += 5;
            _loc6_++;
         }
         var _loc7_:BitmapData = _loc3_.getEmbededBitmapData("flax_dot");
         this.point.x = 10;
         this.point.y = 5;
         _loc6_ = 0;
         while(_loc6_ < param1)
         {
            this.copyPixels(_loc7_,_loc7_.rect,this.point);
            this.point.x += 5;
            _loc6_++;
         }
      }
   }
}

