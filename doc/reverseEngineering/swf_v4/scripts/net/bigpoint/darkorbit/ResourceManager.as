package net.bigpoint.darkorbit
{
   import com.bigpoint.filecollection.FileCollection;
   import com.bigpoint.filecollection.finish.ImageFinisher;
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.media.Sound;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ResourceManager
   {
      
      public static var fileCollection:FileCollection;
      
      public static const logger:ILogger = Log.getLogger("ResourceManager");
      
      private static var lazyLoaderObjects:Array = [];
      
      public function ResourceManager()
      {
         super();
      }
      
      public static function init(param1:String = null) : void
      {
         fileCollection = new FileCollection(true);
         if(param1 != null)
         {
            fileCollection.filePrefix = param1;
         }
      }
      
      public static function getMovieClip(param1:String, param2:String) : MovieClip
      {
         if(SWFFinisher(fileCollection.getFinisher(param1)).hasEmbeddedObject(param2))
         {
            return SWFFinisher(fileCollection.getFinisher(param1)).getEmbededMovieClip(param2);
         }
         return null;
      }
      
      public static function getBitmap(param1:String, param2:String) : Bitmap
      {
         return SWFFinisher(fileCollection.getFinisher(param1)).getEmbededBitmap(param2);
      }
      
      public static function getBitmapData(param1:String, param2:String) : BitmapData
      {
         return SWFFinisher(fileCollection.getFinisher(param1)).getEmbededBitmapData(param2);
      }
      
      public static function getSound(param1:String, param2:String) : Sound
      {
         if(SWFFinisher(fileCollection.getFinisher(param1)).hasEmbeddedObject(param2))
         {
            return SWFFinisher(fileCollection.getFinisher(param1)).getEmbededSound(param2);
         }
         return null;
      }
      
      public static function getImage(param1:String) : DisplayObject
      {
         return ImageFinisher(fileCollection.getFinisher(param1)).getBitmap();
      }
      
      public static function lazyGetAsset(param1:String, param2:Function, param3:Function) : void
      {
         var _loc5_:LazyLoadVO = null;
         if(fileCollection.isLoaded(param1))
         {
            param2(fileCollection.getFinisher(param1));
            return;
         }
         var _loc4_:LazyLoadVO = lazyLoaderObjects[param1] as LazyLoadVO;
         if(_loc4_ != null)
         {
            _loc4_.addCompleteCallback(param2);
            _loc4_.addErrorCallback(param3);
            _loc4_.load();
         }
         else
         {
            _loc5_ = new LazyLoadVO(param1,param2,param3);
            _loc5_.load();
            lazyLoaderObjects[param1] = _loc5_;
         }
      }
   }
}

