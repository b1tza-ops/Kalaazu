package net.bigpoint.darkorbit.refinement
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ServerCommands;
   
   public class SourceRefinementModule extends RefinementModule
   {
      
      private var _iconResKey:String;
      
      private var _oreCount:int = 0;
      
      private var currentIdentifier:String;
      
      private var tooltipKey:String;
      
      public function SourceRefinementModule(param1:RefinementManager, param2:int, param3:String, param4:String, param5:String, param6:String = null)
      {
         super(param1,param2,param3,param4);
         this._iconResKey = param5;
         this.tooltipKey = param6;
         this.init();
         this.buttonMode = true;
      }
      
      public function createOreIcon() : OreIcon
      {
         var _loc1_:Bitmap = finisher.getEmbededBitmap(this._iconResKey);
         var _loc2_:OreIcon = new OreIcon(this.type);
         _loc2_.addChild(_loc1_);
         return _loc2_;
      }
      
      public function updateAmmount() : void
      {
         labelAmmount.setText(this._oreCount.toString());
      }
      
      public function setOreCount(param1:int) : void
      {
         this._oreCount = param1;
      }
      
      private function init() : void
      {
         _background = finisher.getEmbededBitmap("sourceSlot");
         this.addChild(_background);
         var _loc1_:Bitmap = finisher.getEmbededBitmap(resKey);
         _loc1_.x = _background.width / 2 - _loc1_.width / 2;
         _loc1_.y = _background.height / 2 - _loc1_.height / 2;
         this.addChild(_loc1_);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         setLabels();
         this.setAmmount(0);
         if(this.tooltipKey != null)
         {
            TooltipControl.getInstance().addToolTip(this,BPLocale.getText(this.tooltipKey));
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(this._oreCount == 0)
         {
            return;
         }
         var _loc2_:MovieClip = this.createIcon();
         _loc2_.startDrag();
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         var _loc8_:TargetRefinementModule = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:TargetRefinementModule = null;
         var _loc4_:SimpleContainer = _refinementManager.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_TARGET);
         var _loc5_:Array = _loc4_.getAllElements();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(_loc5_[_loc6_] is TargetRefinementModule)
            {
               _loc8_ = _loc5_[_loc6_];
               if(_loc4_.mouseX > _loc8_.x && _loc4_.mouseX < _loc8_.x + _loc8_.width && _loc4_.mouseY > _loc8_.y && _loc4_.mouseY < _loc8_.y + _loc8_.height)
               {
                  _loc3_ = _loc8_;
               }
            }
            _loc6_++;
         }
         if(_loc3_ == null || this.type == 11 && _loc3_.identifier == "SHIELD" || this.type == 11 && _loc3_.identifier == "DRIVING" || this.type == 12 && _loc3_.identifier == "LASER" || this.type == 12 && _loc3_.identifier == "ROCKET" || this.type == 14 && _loc3_.identifier == "DRIVING")
         {
            this.moveToSource(_loc2_);
            return;
         }
         _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         var _loc7_:SimpleWindow = _refinementManager.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT);
         _loc7_.removeChild(_loc2_);
         this.currentIdentifier = _loc3_.identifier;
         if(_loc3_.oreIcon == null)
         {
            this.createCountWindow();
         }
         else if(_loc3_.oreIcon.id == type)
         {
            this.createCountWindow();
         }
         else
         {
            this.createUpdateWindow();
         }
      }
      
      private function createCountWindow() : void
      {
         var _loc1_:SimpleWindow = refinementManager.guiManager.createWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT_COUNT);
         var _loc2_:SimpleContainer = new SimpleContainer(refinementManager.guiManager,SimpleContainer.CLASS_DEFAULT);
         _loc2_.x = 20;
         _loc2_.y = 35;
         var _loc3_:TextFieldElement = new TextFieldElement(340,20,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),BPLocale.getText("lab_count"),TextFormatAlign.LEFT);
         _loc2_.addElement(_loc3_);
         var _loc4_:ComboBoxElement = new ComboBoxElement(refinementManager.guiManager);
         _loc4_.setAvailableAmmount(this._oreCount);
         _loc2_.addElement(_loc4_,SimpleContainer.ALIGN_VERTICAL);
         _loc2_.y = 30;
         var _loc5_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc6_:ButtonElement = new ButtonElement(ButtonElement.TYPE_OK,BPLocale.getText("lab_update"),_loc5_.getEmbededMovieClip("button1"));
         _loc6_.addEventListener(MouseEvent.CLICK,this.onOkCountWindow);
         _loc2_.addElement(_loc6_);
         _loc6_.y = 60;
         var _loc7_:ButtonElement = new ButtonElement(ButtonElement.TYPE_CANCEL,BPLocale.getText("lab_cancel"),_loc5_.getEmbededMovieClip("button1"));
         _loc2_.addElement(_loc7_,SimpleContainer.ALIGN_HORIZONTAL);
         _loc7_.y = 60;
         _loc7_.addEventListener(MouseEvent.CLICK,this.onCloseCountWindow);
         _loc1_.addContainer(_loc2_);
         _loc1_.modal = true;
      }
      
      private function onOkCountWindow(param1:MouseEvent) : void
      {
         var _loc2_:SimpleWindow = refinementManager.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT_COUNT);
         var _loc3_:ComboBoxElement = ComboBoxElement(_loc2_.getContainer(SimpleContainer.CLASS_DEFAULT).getElement(SimpleElement.TYPE_COMBO_BOX_ELEMENT));
         var _loc4_:int = parseInt(_loc3_.comboBox.selectedLabel);
         var _loc5_:Array = [ServerCommands.UPDATE,ServerCommands.SET,this.currentIdentifier,type.toString(),_loc4_.toString()];
         _refinementManager.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.LAB,_loc5_);
         this.closeCountWindow();
      }
      
      private function onCloseCountWindow(param1:MouseEvent) : void
      {
         this.closeCountWindow();
      }
      
      private function closeCountWindow() : void
      {
         var _loc4_:ButtonElement = null;
         var _loc1_:SimpleWindow = refinementManager.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT_COUNT);
         var _loc2_:Array = _loc1_.getContainer(SimpleContainer.CLASS_DEFAULT).getElements(SimpleElement.TYPE_SIMPLE_BUTTON);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.getType() == ButtonElement.TYPE_CANCEL)
            {
               _loc4_.removeEventListener(MouseEvent.CLICK,this.onCloseCountWindow);
            }
            if(_loc4_.getType() == ButtonElement.TYPE_OK)
            {
               _loc4_.removeEventListener(MouseEvent.CLICK,this.onOkCountWindow);
            }
            _loc3_++;
         }
         refinementManager.guiManager.closeWindow(_loc1_);
      }
      
      private function createUpdateWindow() : void
      {
         var _loc1_:SimpleWindow = refinementManager.guiManager.createWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT_UPDATE);
         var _loc2_:SimpleContainer = new SimpleContainer(refinementManager.guiManager,SimpleContainer.CLASS_DEFAULT);
         _loc2_.x = 20;
         _loc2_.y = 35;
         var _loc3_:TextFieldElement = new TextFieldElement(340,50,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),BPLocale.getText("lab_alert"),TextFormatAlign.LEFT);
         _loc2_.addElement(_loc3_);
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc5_:ButtonElement = new ButtonElement(ButtonElement.TYPE_UPDATE,BPLocale.getText("lab_update"),_loc4_.getEmbededMovieClip("button1"));
         _loc5_.addEventListener(MouseEvent.CLICK,this.onOkUpdate);
         _loc2_.addElement(_loc5_);
         var _loc6_:ButtonElement = new ButtonElement(ButtonElement.TYPE_CANCEL,BPLocale.getText("lab_cancel"),_loc4_.getEmbededMovieClip("button1"));
         _loc2_.addElement(_loc6_,SimpleContainer.ALIGN_HORIZONTAL);
         _loc6_.addEventListener(MouseEvent.CLICK,this.onCancelUpdate);
         _loc1_.addContainer(_loc2_);
         _loc1_.modal = true;
      }
      
      private function onOkUpdate(param1:MouseEvent) : void
      {
         this.closeUpdateWindow();
         this.createCountWindow();
      }
      
      private function onCancelUpdate(param1:MouseEvent) : void
      {
         this.closeUpdateWindow();
      }
      
      private function closeUpdateWindow() : void
      {
         var _loc4_:ButtonElement = null;
         var _loc1_:SimpleWindow = refinementManager.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT_UPDATE);
         var _loc2_:Array = _loc1_.getContainer(SimpleContainer.CLASS_DEFAULT).getElements(SimpleElement.TYPE_SIMPLE_BUTTON);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.getType() == ButtonElement.TYPE_UPDATE)
            {
            }
            if(_loc4_.getType() == ButtonElement.TYPE_CANCEL)
            {
               _loc4_.removeEventListener(MouseEvent.CLICK,this.onCancelUpdate);
            }
            _loc3_++;
         }
         refinementManager.guiManager.closeWindow(_loc1_);
      }
      
      private function moveToSource(param1:MovieClip) : void
      {
         var _loc2_:SimpleContainer = _refinementManager.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         var _loc3_:int = _loc2_.x + this.x + this.width / 2;
         var _loc4_:int = _loc2_.y + this.y + this.height / 2;
         TweenLite.to(param1,0.25,{
            "alpha":0,
            "x":_loc3_,
            "y":_loc4_,
            "onComplete":this.onResetIcon,
            "onCompleteParams":[param1]
         });
      }
      
      public function createIcon(param1:Boolean = true) : MovieClip
      {
         var _loc2_:SimpleWindow = _refinementManager.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT);
         var _loc3_:Bitmap = finisher.getEmbededBitmap(this._iconResKey);
         var _loc4_:MovieClip = new MovieClip();
         _loc4_.addChild(_loc3_);
         _loc4_.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         _loc4_.x = _loc2_.mouseX - _loc4_.width / 2;
         _loc4_.y = _loc2_.mouseY - _loc4_.height / 2;
         _loc2_.addChild(_loc4_);
         if(param1)
         {
            _loc4_.alpha = 0;
            TweenLite.to(_loc4_,0.25,{
               "ease":Linear.easeNone,
               "alpha":1
            });
         }
         return _loc4_;
      }
      
      private function onResetIcon(param1:MovieClip) : void
      {
         var _loc2_:SimpleWindow = _refinementManager.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT);
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         _loc2_.removeChild(param1);
      }
      
      public function setAmmount(param1:int) : void
      {
         labelAmmount.setText(param1.toString());
      }
   }
}

