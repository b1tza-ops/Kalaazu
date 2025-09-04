package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   
   public class ConnectionElement extends SimpleElement
   {
      
      public function ConnectionElement()
      {
         super(TYPE_CONNECTION);
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc2_:MovieClip = MovieClip(_loc1_.getEmbededMovieClip("connectionWindow"));
         _loc2_.mouseEnabled = Main.mouseEventsEnabled;
         _loc2_.mouseChildren = Main.mouseEventsEnabled;
         _loc2_.txtHeader.text = "";
         var _loc3_:TextField = TextField(_loc2_.txtBody);
         _loc3_.defaultTextFormat = Styles.simpleFmt;
         _loc3_.embedFonts = Styles.simpleEmbed;
         _loc3_.text = BPLocale.getText("log_verbinde");
         var _loc4_:TextField = TextField(_loc2_.txtBottom);
         _loc4_.defaultTextFormat = Styles.simpleFmt;
         _loc4_.embedFonts = Styles.simpleEmbed;
         _loc4_.text = BPLocale.getText("log_warten");
         _loc4_.height = Styles.simpleFontHeight + 5;
         this.addChild(_loc2_);
      }
   }
}

