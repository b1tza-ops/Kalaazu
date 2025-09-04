package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Interference;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   
   public class VideoElement extends SimpleElement
   {
      
      public static const CLASS_COMMANDER:int = 0;
      
      public static const CLASS_HELPMOVIE:int = 1;
      
      private var videoID:int;
      
      private var classID:int;
      
      private var factionID:int;
      
      private var video:MovieClip;
      
      private var cMask:MovieClip;
      
      public var interference:Interference;
      
      public var border:Bitmap;
      
      public function VideoElement(param1:int, param2:int = 0, param3:int = 0)
      {
         super(TYPE_VIDEO_ELEMENT);
         this.videoID = param1;
         this.classID = param2;
         this.factionID = param3;
         this.init();
      }
      
      public static function getContentResKey(param1:int, param2:int) : String
      {
         var _loc3_:String = "";
         if(param1 == CLASS_COMMANDER)
         {
            _loc3_ = "videoPic";
         }
         else if(param1 == CLASS_HELPMOVIE)
         {
            _loc3_ = "helpmovie";
         }
         _loc3_ += "_" + param2;
         if(param1 == CLASS_HELPMOVIE && param2 == 1)
         {
            _loc3_ += "_faction" + Hero.factionID;
         }
         return _loc3_;
      }
      
      public function init() : void
      {
         var _loc1_:String = getContentResKey(this.classID,this.videoID);
         this.video = ResourceManager.getMovieClip(_loc1_,"video");
         this.video.mask = this.cMask;
         ScreenManager.playAnimation(this.video,20,true);
         this.interference = new Interference(this.video.width,this.video.height);
         this.interference.playSound = false;
         if(this.classID == CLASS_COMMANDER)
         {
            this.interference.fadeOut = false;
            this.interference.start();
            this.video.addChild(this.interference);
         }
         this.addChild(this.video);
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.cMask = _loc2_.getEmbededMovieClip("cMask");
         this.addChild(this.cMask);
         this.video.mask = this.cMask;
         this.border = _loc2_.getEmbededBitmap("border");
         this.addChild(this.border);
      }
      
      override public function get width() : Number
      {
         if(this.border != null)
         {
            return this.border.width;
         }
         return super.width;
      }
      
      public function cleanup() : void
      {
         this.interference.cleanup();
         ScreenManager.stopAnimation(this.video);
         this.video.mask = null;
         removeChild(this.cMask);
         removeChild(this.border);
         removeChild(this.video);
      }
   }
}

