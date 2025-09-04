package net.bigpoint.darkorbit.gui
{
   import flash.geom.Rectangle;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TechSlotElement;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.models.TechModel;
   
   public class TechView
   {
      
      public static const logger:ILogger = Log.getLogger("TechView");
      
      private static const CONTENT_PADDING_X:int = 15;
      
      private static const CONTENT_PADDING_Y:int = 38;
      
      private static const MINIMUM_WIDTH:int = 96;
      
      private var main:Main;
      
      private var techModel:TechModel;
      
      private var coolDowns:Array = [];
      
      public function TechView(param1:Main, param2:TechModel)
      {
         super();
         this.techModel = param2;
         this.main = param1;
      }
      
      private function getView() : SimpleWindow
      {
         var _loc2_:SimpleContainer = null;
         var _loc3_:int = 0;
         var _loc1_:SimpleWindow = this.main.getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_TECHS);
         if(_loc1_ == null)
         {
            _loc1_ = this.main.getGuiManager().createWindow(SimpleWindow.WINDOW_CLASS_TECHS);
            _loc2_ = new SimpleContainer(this.main.getGuiManager(),SimpleContainer.CLASS_TECHS);
            _loc1_.addContainer(_loc2_);
            _loc3_ = 1;
            while(_loc3_ < this.techModel.techs.length)
            {
               this.addSlotElementAt(_loc2_);
               _loc3_++;
            }
            _loc2_.x = CONTENT_PADDING_X;
            _loc2_.y = CONTENT_PADDING_Y;
         }
         return _loc1_;
      }
      
      private function addSlotElementAt(param1:SimpleContainer) : void
      {
         var _loc2_:TechSlotElement = new TechSlotElement(this.main);
         _loc2_.handleClickCallBack = this.handleSlotClick;
         param1.addElement(_loc2_,SimpleContainer.ALIGN_HORIZONTAL,5);
      }
      
      public function update() : void
      {
         var _loc3_:TechSlotElement = null;
         var _loc7_:SimpleContainer = null;
         var _loc8_:int = 0;
         var _loc1_:SimpleWindow = this.getView();
         var _loc2_:Array = _loc1_.getContainer(SimpleContainer.CLASS_TECHS).getElements(SimpleElement.TYPE_TECH);
         if(_loc2_.length < this.techModel.techs.length - 1)
         {
            _loc7_ = _loc1_.getContainer(SimpleContainer.CLASS_TECHS);
            _loc8_ = _loc2_.length + 1;
            while(_loc8_ < this.techModel.techs.length)
            {
               this.addSlotElementAt(_loc7_);
               _loc8_++;
            }
            _loc2_ = _loc7_.getElements(SimpleElement.TYPE_TECH);
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_] as TechSlotElement;
            _loc4_++;
         }
         var _loc5_:Rectangle = _loc1_.getContainer(SimpleContainer.CLASS_TECHS).getRect(_loc1_);
         var _loc6_:int = Math.max(_loc5_.width + CONTENT_PADDING_X,MINIMUM_WIDTH);
         _loc1_.setDimension(_loc6_,_loc5_.height + CONTENT_PADDING_Y);
      }
      
      public function handleSlotClick(param1:int) : void
      {
         this.techModel.activateTechInSlot(param1);
      }
   }
}

