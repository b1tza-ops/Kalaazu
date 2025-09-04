package net.bigpoint.darkorbit.refinement
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RefinerInfo;
   
   public class RefinementManager
   {
      
      public static const logger:ILogger = Log.getLogger("RefinementManager");
      
      private var _guiManager:GuiManager;
      
      private var refinementButton:ButtonElement;
      
      private var updateButton:ButtonElement;
      
      private var oreIDToProduce:int;
      
      private var itemRefreshTimer:Timer;
      
      public function RefinementManager(param1:GuiManager)
      {
         super();
         this._guiManager = param1;
         this.createRefinementWindow();
         this.refreshItemList();
      }
      
      public function updateOreCounts() : void
      {
         var _loc1_:Array = null;
         var _loc2_:SimpleContainer = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:OrePattern = null;
         var _loc7_:StaticRefinementModule = null;
         var _loc8_:SourceRefinementModule = null;
         var _loc9_:StaticRefinementModule = null;
         var _loc10_:StaticRefinementModule = null;
         _loc1_ = Hero.getOres([OrePattern.ORE_PROMETIUM,OrePattern.ORE_ENDURIUM,OrePattern.ORE_TERBIUM,OrePattern.ORE_XENOMIT,OrePattern.ORE_PALLADIUM]);
         _loc2_ = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_STATIC);
         _loc3_ = _loc2_.getAllElements();
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] is StaticRefinementModule)
            {
               _loc7_ = _loc3_[_loc5_];
               _loc6_ = _loc1_[_loc4_++];
               _loc7_.setOreCount(_loc6_.count);
               _loc7_.updateAmmount();
            }
            _loc5_++;
         }
         _loc1_ = Hero.getOres([OrePattern.ORE_PROMETID,OrePattern.ORE_DURANIUM,OrePattern.ORE_PROMERIUM,OrePattern.ORE_SEPROM]);
         _loc2_ = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         _loc3_ = _loc2_.getAllElements();
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] is SourceRefinementModule)
            {
               _loc8_ = _loc3_[_loc5_];
               _loc6_ = _loc1_[_loc4_++];
               _loc8_.setOreCount(_loc6_.count);
               _loc8_.updateAmmount();
            }
            _loc5_++;
         }
         _loc2_ = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT).getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_STATIC);
         _loc3_ = _loc2_.getAllElements();
         _loc1_ = Hero.getOres([OrePattern.ORE_PROMETIUM,OrePattern.ORE_ENDURIUM,OrePattern.ORE_TERBIUM]);
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] is StaticRefinementModule)
            {
               _loc9_ = _loc3_[_loc5_];
               _loc6_ = _loc1_[_loc4_++];
               _loc9_.setOreCount(_loc6_.count);
               _loc9_.updateAmmount();
            }
            _loc5_++;
         }
         _loc2_ = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT).getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_SOURCE);
         _loc3_ = _loc2_.getAllElements();
         _loc1_ = Hero.getOres([OrePattern.ORE_PROMETID,OrePattern.ORE_DURANIUM,OrePattern.ORE_PROMERIUM,OrePattern.ORE_XENOMIT]);
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] is StaticRefinementModule)
            {
               _loc10_ = _loc3_[_loc5_];
               _loc6_ = _loc1_[_loc4_++];
               _loc10_.setOreCount(_loc6_.count);
               _loc10_.updateAmmount();
            }
            _loc5_++;
         }
      }
      
      public function updateItem(param1:String, param2:int, param3:int) : void
      {
         var _loc6_:OreIcon = null;
         var _loc4_:TargetRefinementModule = this.getTargetRefinementModule(param1);
         if(_loc4_ != null)
         {
            _loc4_.setAmmount(param3);
         }
         var _loc5_:SourceRefinementModule = this.getSourceRefinementModule(param2);
         if(_loc5_ != null)
         {
            _loc4_.removeOreIcon();
            if(param3 > 0)
            {
               _loc6_ = _loc5_.createOreIcon();
               _loc4_.setOreIcon(_loc6_);
            }
         }
      }
      
      private function getTargetRefinementModule(param1:String) : TargetRefinementModule
      {
         var _loc5_:TargetRefinementModule = null;
         var _loc2_:SimpleContainer = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_TARGET);
         var _loc3_:Array = _loc2_.getAllElements();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] is TargetRefinementModule)
            {
               _loc5_ = _loc3_[_loc4_];
               if(_loc5_.identifier == param1)
               {
                  return _loc5_;
               }
            }
            _loc4_++;
         }
         return null;
      }
      
      private function getSourceRefinementModule(param1:int) : SourceRefinementModule
      {
         var _loc5_:SourceRefinementModule = null;
         var _loc2_:SimpleContainer = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT).getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         var _loc3_:Array = _loc2_.getAllElements();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] is SourceRefinementModule)
            {
               _loc5_ = _loc3_[_loc4_];
               if(_loc5_.type == param1)
               {
                  return _loc5_;
               }
            }
            _loc4_++;
         }
         return null;
      }
      
      private function onRefinementTab(param1:MouseEvent) : void
      {
         this.setVisibility(true);
      }
      
      private function onUpdateTab(param1:MouseEvent) : void
      {
         this.setVisibility(false);
      }
      
      private function setVisibility(param1:Boolean) : void
      {
         var _loc2_:SimpleWindow = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT);
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_STATIC);
         var _loc4_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         var _loc5_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_TARGET);
         var _loc6_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_STATIC);
         var _loc7_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_SOURCE);
         var _loc8_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_BUTTONS);
         var _loc9_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_TREE);
         _loc6_.visible = param1;
         _loc7_.visible = param1;
         _loc8_.visible = param1;
         _loc9_.visible = param1;
         this.refinementButton.selected = param1;
         _loc3_.visible = !param1;
         _loc4_.visible = !param1;
         _loc5_.visible = !param1;
         this.updateButton.selected = !param1;
      }
      
      public function createRefinementWindow() : void
      {
         var _loc2_:SWFFinisher = null;
         var _loc3_:SimpleContainer = null;
         var _loc4_:SimpleElement = null;
         var _loc5_:Sprite = null;
         var _loc1_:SimpleWindow = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT);
         if(_loc1_ == null)
         {
            _loc1_ = this._guiManager.createWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT);
            _loc1_.addEventListener(SimpleWindow.ON_MAXIMIZE_CLICKED,this.onRefinementWindowMaximized);
            _loc1_.addEventListener(SimpleWindow.ON_MINIMIZE_CLICKED,this.onRefinementWindowMinimized);
            _loc2_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc3_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_BUTTONS);
            this.refinementButton = new ButtonElement(ButtonElement.TYPE_REFINEMENT_REFINEMENT,BPLocale.getText("lab_btn_refinement"),_loc2_.getEmbededMovieClip("button1"));
            this.refinementButton.selected = true;
            this.refinementButton.addEventListener(MouseEvent.CLICK,this.onRefinementTab);
            _loc3_.addElement(this.refinementButton);
            this.updateButton = new ButtonElement(ButtonElement.TYPE_REFINEMENT_UPDATE,BPLocale.getText("lab_btn_update"),_loc2_.getEmbededMovieClip("button1"));
            this.updateButton.addEventListener(MouseEvent.CLICK,this.onUpdateTab);
            _loc3_.addElement(this.updateButton,SimpleContainer.ALIGN_HORIZONTAL);
            _loc4_ = new SimpleElement(SimpleElement.TYPE_DEFAULT_ELEMENT);
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(1,8289918);
            _loc5_.graphics.moveTo(0,0);
            _loc5_.graphics.lineTo(434,0);
            _loc4_.addChild(_loc5_);
            _loc4_.y = 20;
            _loc3_.addElement(_loc4_,SimpleContainer.NO_ALIGN,0);
            _loc1_.addContainer(_loc3_);
            this.createRefinementContainers();
            this.createUpdateContainers();
            if(_loc1_.isMaximized())
            {
               this.startRefreshTimer();
            }
         }
      }
      
      private function onRefinementWindowMaximized(param1:Event) : void
      {
         this.killRefreshTimer();
         this.startRefreshTimer();
         this.refreshItemList();
      }
      
      private function onRefinementWindowMinimized(param1:Event) : void
      {
         this.killRefreshTimer();
      }
      
      private function startRefreshTimer() : void
      {
         this.itemRefreshTimer = new Timer(1000,600);
         this.itemRefreshTimer.addEventListener(TimerEvent.TIMER,this.onRefreshItems);
         this.itemRefreshTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.handleTimerComplete);
         this.itemRefreshTimer.start();
      }
      
      private function handleTimerComplete(param1:Event) : void
      {
         var _loc2_:SimpleWindow = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT);
         _loc2_.minimize(true);
      }
      
      private function killRefreshTimer() : void
      {
         if(this.itemRefreshTimer != null)
         {
            this.itemRefreshTimer.stop();
            this.itemRefreshTimer.removeEventListener(TimerEvent.TIMER,this.onRefreshItems);
            this.itemRefreshTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.handleTimerComplete);
            this.itemRefreshTimer = null;
         }
      }
      
      private function onRefreshItems(param1:TimerEvent) : void
      {
         this.refreshItemList();
      }
      
      private function refreshItemList() : void
      {
         this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.LAB,[ServerCommands.UPDATE,ServerCommands.GET]);
      }
      
      private function createRefinementContainers() : void
      {
         var _loc8_:int = 0;
         var _loc9_:OrePattern = null;
         var _loc10_:String = null;
         var _loc11_:XML = null;
         var _loc12_:SimpleContainer = null;
         var _loc13_:SimpleContainer = null;
         var _loc14_:StaticRefinementModule = null;
         var _loc15_:StaticRefinementModule = null;
         var _loc16_:int = 0;
         var _loc17_:StaticRefinementModule = null;
         var _loc18_:String = null;
         var _loc19_:Array = null;
         var _loc20_:RefinerInfo = null;
         var _loc21_:OrePattern = null;
         var _loc22_:Boolean = false;
         var _loc23_:StaticRefinementModule = null;
         var _loc24_:Array = null;
         var _loc25_:int = 0;
         var _loc26_:ButtonElement = null;
         var _loc1_:SimpleWindow = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT);
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc3_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_TREE);
         var _loc4_:SimpleElement = new SimpleElement(SimpleElement.TYPE_DEFAULT_ELEMENT);
         _loc4_.addChild(_loc2_.getEmbededBitmap("ore_tree"));
         _loc3_.addElement(_loc4_);
         _loc1_.addContainer(_loc3_);
         var _loc5_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_STATIC);
         var _loc6_:int = 0;
         var _loc7_:int = 8;
         for each(_loc11_ in Main.gameXML.refinementWindow.refinement.staticOres.ore)
         {
            _loc8_ = parseInt(_loc11_.attribute("type"));
            _loc9_ = PatternManager.orePatterns[_loc8_];
            _loc10_ = null;
            if(_loc11_.attribute("tooltipKey").length() > 0)
            {
               _loc10_ = BPLocale.getText(_loc11_.attribute("tooltipKey"));
            }
            _loc17_ = new StaticRefinementModule(this,_loc8_,_loc9_.languageKey,_loc9_.getResKey(),_loc10_);
            _loc17_.x = _loc6_;
            _loc17_.y = 40;
            _loc6_ = _loc6_ + _loc17_.background.width + _loc7_;
            _loc5_.addElement(_loc17_,SimpleContainer.NO_ALIGN,1);
         }
         _loc1_.addContainer(_loc5_);
         _loc12_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_SOURCE);
         _loc13_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_REFINEMENT_BUTTONS);
         _loc6_ = 0;
         _loc7_ = 8;
         for each(_loc11_ in Main.gameXML.refinementWindow.refinement.ores.ore)
         {
            _loc8_ = parseInt(_loc11_.attribute("type"));
            _loc9_ = PatternManager.orePatterns[_loc8_];
            _loc10_ = null;
            _loc18_ = _loc11_.attribute("tooltipKey");
            if(_loc18_.length > 0)
            {
               _loc24_ = _loc18_.split(",");
               if(_loc24_.length > 1)
               {
                  _loc10_ = "";
                  _loc25_ = 0;
                  while(_loc25_ < _loc24_.length)
                  {
                     _loc10_ += BPLocale.getText(_loc24_[_loc25_]) + "\n";
                     _loc25_++;
                  }
               }
               else
               {
                  _loc10_ = BPLocale.getText(_loc11_.attribute("tooltipKey"));
               }
            }
            _loc19_ = _loc9_.refiners;
            if(_loc19_[0])
            {
               _loc20_ = _loc19_[0];
               _loc21_ = PatternManager.orePatterns[_loc20_.oreID];
               _loc10_ = _loc10_.replace("%COUNT_1%",_loc20_.count);
               _loc10_ = _loc10_.replace("%ORE_1%",BPLocale.getText(_loc21_.languageKey));
            }
            if(_loc19_[1])
            {
               _loc20_ = _loc19_[1];
               _loc21_ = PatternManager.orePatterns[_loc20_.oreID];
               _loc10_ = _loc10_.replace("%COUNT_2%",_loc20_.count);
               _loc10_ = _loc10_.replace("%ORE_2%",BPLocale.getText(_loc21_.languageKey));
            }
            if(_loc19_[2])
            {
               _loc20_ = _loc19_[2];
               _loc21_ = PatternManager.orePatterns[_loc20_.oreID];
               _loc10_ = _loc10_.replace("%COUNT%",_loc20_.count);
               _loc10_ = _loc10_.replace("%ORE%",BPLocale.getText(_loc21_.languageKey));
            }
            _loc22_ = false;
            if(_loc11_.attribute("button").length() > 0)
            {
               _loc22_ = Main.parseBooleanFromString(_loc11_.attribute("button"));
            }
            _loc23_ = new StaticRefinementModule(this,_loc8_,_loc9_.languageKey,_loc9_.getResKey(),_loc10_);
            _loc23_.x = _loc6_;
            _loc23_.y = 55;
            if(_loc22_)
            {
               _loc26_ = new ButtonElement(ButtonElement.TYPE_REFINEMENT_REFINEMENT,BPLocale.getText("lab_btn_refine"),_loc2_.getEmbededMovieClip("button1"));
               _loc26_.addEventListener(MouseEvent.CLICK,this.onRefine);
               _loc26_.width = _loc23_.width;
               _loc26_.y = 100;
               _loc23_.addChild(_loc26_);
            }
            _loc6_ = _loc6_ + _loc23_.background.width + _loc7_;
            _loc12_.addElement(_loc23_,SimpleContainer.NO_ALIGN,1);
         }
         _loc14_ = StaticRefinementModule(_loc12_.getElementAt(2));
         _loc14_.y = 215;
         _loc14_.x = 42;
         _loc15_ = StaticRefinementModule(_loc12_.getElementAt(3));
         _loc15_.x = 220;
         _loc16_ = _loc12_.width > _loc5_.width ? int(_loc12_.width) : int(_loc5_.width);
         _loc12_.x = _loc3_.x = 260 - _loc16_ / 2;
         _loc5_.x = _loc12_.x - 47;
         _loc1_.addContainer(_loc12_);
         _loc1_.addContainer(_loc13_);
      }
      
      private function onRefine(param1:MouseEvent) : void
      {
         var _loc2_:ButtonElement = param1.currentTarget as ButtonElement;
         var _loc3_:StaticRefinementModule = _loc2_.parent as StaticRefinementModule;
         this.oreIDToProduce = _loc3_.type;
         var _loc4_:SimpleWindow = this.guiManager.createWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT_REFINE);
         var _loc5_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_DEFAULT);
         _loc5_.x = 20;
         _loc5_.y = 35;
         var _loc6_:TextFieldElement = new TextFieldElement(200,20,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),BPLocale.getText(_loc3_.languageKey),TextFormatAlign.LEFT);
         _loc5_.addElement(_loc6_);
         var _loc7_:TextFieldElement = new TextFieldElement(200,20,new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFmt.size,16777215),BPLocale.getText("lab_refine_question"),TextFormatAlign.LEFT);
         _loc5_.addElement(_loc7_,SimpleContainer.ALIGN_VERTICAL);
         var _loc8_:ComboBoxElement = new ComboBoxElement(this.guiManager);
         _loc5_.addElement(_loc8_,SimpleContainer.ALIGN_VERTICAL);
         this.fillComboBox(_loc3_.type,_loc8_);
         var _loc9_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc10_:ButtonElement = new ButtonElement(ButtonElement.TYPE_OK,BPLocale.getText("lab_btn_refine"),_loc9_.getEmbededMovieClip("button1"));
         _loc10_.addEventListener(MouseEvent.CLICK,this.onOkBtn);
         _loc5_.addElement(_loc10_);
         _loc10_.y = 90;
         var _loc11_:ButtonElement = new ButtonElement(ButtonElement.TYPE_CANCEL,BPLocale.getText("lab_cancel"),_loc9_.getEmbededMovieClip("button1"));
         _loc11_.addEventListener(MouseEvent.CLICK,this.onCancelBtn);
         _loc5_.addElement(_loc11_,SimpleContainer.ALIGN_HORIZONTAL);
         _loc4_.addContainer(_loc5_);
         _loc4_.modal = true;
      }
      
      private function onOkBtn(param1:MouseEvent) : void
      {
         var _loc2_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT_REFINE);
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_DEFAULT);
         var _loc4_:ComboBoxElement = ComboBoxElement(_loc3_.getElement(SimpleElement.TYPE_COMBO_BOX_ELEMENT));
         var _loc5_:int = parseInt(_loc4_.comboBox.selectedLabel);
         var _loc6_:Array = [ServerCommands.REFINEMENT,ServerCommands.PRODUCE,this.oreIDToProduce.toString(),_loc5_.toString()];
         this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.LAB,_loc6_);
         this.closeRefinePopup();
      }
      
      private function onCancelBtn(param1:MouseEvent) : void
      {
         this.closeRefinePopup();
      }
      
      private function closeRefinePopup() : void
      {
         var _loc5_:ButtonElement = null;
         var _loc1_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT_REFINE);
         var _loc2_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_DEFAULT);
         var _loc3_:Array = _loc2_.getElements(SimpleElement.TYPE_SIMPLE_BUTTON);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.getType() == ButtonElement.TYPE_OK)
            {
               _loc5_.removeEventListener(MouseEvent.CLICK,this.onOkBtn);
            }
            if(_loc5_.getType() == ButtonElement.TYPE_CANCEL)
            {
               _loc5_.removeEventListener(MouseEvent.CLICK,this.onCancelBtn);
            }
            _loc4_++;
         }
         this.guiManager.closeWindow(_loc1_);
      }
      
      private function fillComboBox(param1:int, param2:ComboBoxElement) : void
      {
         var _loc11_:OrePattern = null;
         var _loc3_:OrePattern = PatternManager.orePatterns[param1];
         var _loc4_:Array = _loc3_.refiners;
         var _loc5_:RefinerInfo = _loc4_[0];
         var _loc6_:RefinerInfo = _loc4_[1];
         var _loc7_:RefinerInfo = _loc4_[2];
         var _loc8_:OrePattern = PatternManager.orePatterns[_loc5_.oreID];
         var _loc9_:OrePattern = PatternManager.orePatterns[_loc6_.oreID];
         var _loc10_:int = Math.min(_loc8_.count / _loc5_.count,_loc9_.count / _loc6_.count);
         if(_loc7_)
         {
            _loc11_ = PatternManager.orePatterns[_loc7_.oreID];
            _loc10_ = Math.min(_loc10_,_loc11_.count / _loc7_.count);
         }
         param2.setAvailableAmmount(_loc10_);
      }
      
      private function createUpdateContainers() : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:OrePattern = null;
         var _loc8_:XML = null;
         var _loc9_:SimpleContainer = null;
         var _loc10_:TextFieldElement = null;
         var _loc11_:SimpleContainer = null;
         var _loc12_:XML = null;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:StaticRefinementModule = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:SourceRefinementModule = null;
         var _loc19_:int = 0;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:String = null;
         var _loc24_:TargetRefinementModule = null;
         var _loc1_:SimpleWindow = this._guiManager.getWindow(SimpleWindow.WINDOW_CLASS_REFINEMENT);
         var _loc2_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_STATIC);
         _loc2_.visible = false;
         var _loc3_:TextFieldElement = new TextFieldElement(340,20,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),BPLocale.getText("lab_title"),TextFormatAlign.LEFT);
         _loc2_.addElement(_loc3_);
         _loc4_ = 0;
         var _loc5_:int = 8;
         for each(_loc8_ in Main.gameXML.refinementWindow.update.staticOres.ore)
         {
            _loc6_ = parseInt(_loc8_.attribute("type"));
            _loc7_ = PatternManager.orePatterns[_loc6_];
            _loc14_ = null;
            if(_loc8_.attribute("tooltipKey").length() > 0)
            {
               _loc14_ = BPLocale.getText(_loc8_.attribute("tooltipKey"));
            }
            _loc15_ = new StaticRefinementModule(this,_loc6_,_loc7_.languageKey,_loc7_.getResKey(),_loc14_);
            _loc15_.x = _loc4_;
            _loc15_.y = 40;
            _loc4_ = _loc4_ + _loc15_.background.width + _loc5_;
            _loc2_.addElement(_loc15_,SimpleContainer.NO_ALIGN,1);
         }
         _loc1_.addContainer(_loc2_);
         _loc9_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_SOURCE);
         _loc9_.visible = false;
         _loc10_ = new TextFieldElement(340,40,new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFmt.size,16777215),BPLocale.getText("labor_intro"),TextFormatAlign.LEFT);
         _loc9_.addElement(_loc10_);
         _loc4_ = 0;
         _loc5_ = 8;
         for each(_loc8_ in Main.gameXML.refinementWindow.update.ores.ore)
         {
            _loc6_ = parseInt(_loc8_.attribute("type"));
            _loc7_ = PatternManager.orePatterns[_loc6_];
            _loc16_ = _loc8_.attribute("iconResKey");
            _loc17_ = _loc8_.attribute("tooltipKey");
            _loc18_ = new SourceRefinementModule(this,_loc6_,_loc7_.languageKey,_loc7_.getResKey(),_loc16_,_loc17_);
            _loc18_.x = _loc4_;
            _loc18_.y = 55;
            _loc4_ = _loc4_ + _loc18_.background.width + _loc5_;
            _loc9_.addElement(_loc18_,SimpleContainer.NO_ALIGN,1);
         }
         _loc1_.addContainer(_loc9_);
         _loc11_ = _loc1_.getContainer(SimpleContainer.CLASS_REFINEMENT_UPDATE_TARGET);
         _loc11_.visible = false;
         _loc4_ = 0;
         for each(_loc12_ in Main.gameXML.refinementWindow.update.items.item)
         {
            _loc19_ = parseInt(_loc12_.attribute("type"));
            _loc20_ = _loc12_.attribute("languageKey");
            _loc21_ = _loc12_.attribute("resKey");
            _loc22_ = _loc12_.attribute("identifier");
            _loc23_ = _loc12_.attribute("ammountKey");
            _loc24_ = new TargetRefinementModule(this,_loc19_,_loc20_,_loc21_,_loc22_,_loc23_);
            _loc24_.x = _loc4_;
            _loc4_ = _loc4_ + _loc24_.background.width + _loc5_;
            _loc11_.addElement(_loc24_,SimpleContainer.NO_ALIGN,1);
         }
         _loc1_.addContainer(_loc11_);
         _loc13_ = _loc11_.width > _loc9_.width ? int(_loc11_.width) : int(_loc9_.width);
         _loc9_.x = _loc11_.x = 230 - _loc13_ / 2;
      }
      
      public function get guiManager() : GuiManager
      {
         return this._guiManager;
      }
   }
}

