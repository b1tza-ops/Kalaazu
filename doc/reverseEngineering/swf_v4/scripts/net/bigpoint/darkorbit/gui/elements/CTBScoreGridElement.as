package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.ResourceManager;
   
   public class CTBScoreGridElement extends SimpleElement
   {
      
      public function CTBScoreGridElement()
      {
         super(TYPE_CTB_SCORE_GRID);
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.addChild(_loc1_.getEmbededBitmap("ctb_table"));
      }
   }
}

