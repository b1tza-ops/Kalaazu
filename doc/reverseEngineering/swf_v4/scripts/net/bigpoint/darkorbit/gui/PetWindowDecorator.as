package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import flash.display.Bitmap;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.components.BarComponent;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearComboBox;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearMenuContainer;
   import net.bigpoint.darkorbit.gui.windows.components.gear.GearScroller;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class PetWindowDecorator
   {
      
      public static const logger:ILogger = Log.getLogger("PetWindowDecorator");
      
      public static const barColors:Array = [65280,255,16711680,16777215];
      
      public static const EXPANDED_WINDOW_HEIGHT:int = 45;
      
      public static const IMAGE_SIZE_MAX:int = 70;
      
      public static const BORDER:int = 10;
      
      private var petNameTextfield:TextField;
      
      private var windowIcon:Bitmap;
      
      private var playButton:MovieClip;
      
      private var stopButton:MovieClip;
      
      private var fuelButton:MovieClip;
      
      private var expandButton:MovieClip;
      
      private var repairButton:MovieClip;
      
      private var collapsableContainer:Sprite;
      
      private var windowComponentsContainer:SimpleContainer;
      
      private var guiManager:GuiManager;
      
      private var barIcons:Array;
      
      private var window:SimpleWindow;
      
      private var gearsCombo:GearComboBox;
      
      public function PetWindowDecorator(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
      }
      
      public function decorate(param1:SimpleWindow) : void
      {
         this.getAssets();
         this.window = param1;
         this.windowComponentsContainer = this.window.getContainer(SimpleContainer.CLASS_PET_WINDOW_CONTENT);
         param1.resizer.removeEventListener(MouseEvent.MOUSE_DOWN,param1.handleMouseDownResizer);
         param1.setLabelText("title_pet");
         this.initInfoBars();
         this.initButtons();
         this.initCollapsableMenu();
         this.initComboBoxBody();
      }
      
      private function initComboBoxBody() : void
      {
         var _loc1_:GearMenuContainer = new GearMenuContainer();
         _loc1_.x = BORDER * 13;
         _loc1_.y = BORDER * 13;
         var _loc2_:GearScroller = new GearScroller();
         _loc1_.addMainMenu(_loc2_);
         this.window.addChild(_loc1_);
      }
      
      private function initCollapsableMenu() : void
      {
         var _loc1_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_BUFF_CONTAINER);
         this.collapsableContainer = new Sprite();
         _loc1_.addChild(this.collapsableContainer);
         _loc1_.x = 0;
         _loc1_.y = BORDER * 13;
         this.windowComponentsContainer.addElement(_loc1_,SimpleContainer.NO_ALIGN);
         if(Settings.resolutionID > 0)
         {
            this.handleExpandButtonClick();
         }
      }
      
      private function initButtons() : void
      {
         var _loc1_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_PLAY_BTN);
         var _loc2_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_STOP_BTN);
         var _loc3_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_REPAIR_BTN);
         var _loc4_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_FUEL_BTN);
         var _loc5_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_EXPAND_BTN);
         var _loc6_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_GEAR_COMBO_CONTAINER);
         this.repairButton.gotoAndStop(1);
         this.playButton.gotoAndStop(1);
         this.stopButton.gotoAndStop(1);
         this.fuelButton.gotoAndStop(1);
         this.expandButton.gotoAndStop(1);
         this.repairButton.buttonMode = this.repairButton.useHandCursor = true;
         this.playButton.buttonMode = this.playButton.useHandCursor = true;
         this.stopButton.buttonMode = this.stopButton.useHandCursor = true;
         this.fuelButton.buttonMode = this.fuelButton.useHandCursor = true;
         this.expandButton.buttonMode = this.expandButton.useHandCursor = true;
         this.repairButton.visible = false;
         this.expandButton.addEventListener(MouseEvent.CLICK,this.handleExpandButtonClick);
         this.gearsCombo = new GearComboBox();
         _loc6_.addChild(this.gearsCombo);
         this.gearsCombo.init();
         this.addTooltip(this.playButton,"label_activate_pet");
         this.addTooltip(this.repairButton,"ttip_repair_pet");
         this.addTooltip(this.stopButton,"label_deactivate_pet");
         this.addTooltip(this.gearsCombo,"ttip_pet_gear_combobox");
         this.addTooltip(this.fuelButton,"ttip_buy_pet_fuel");
         _loc2_.addChild(this.stopButton);
         _loc1_.addChild(this.playButton);
         _loc3_.addChild(this.repairButton);
         _loc4_.addChild(this.fuelButton);
         _loc5_.addChild(this.expandButton);
         _loc3_.x = _loc2_.x = _loc1_.x = BORDER;
         _loc4_.x = BORDER * 7;
         _loc6_.x = BORDER * 12;
         _loc2_.y = _loc1_.y = _loc3_.y = _loc4_.y = _loc5_.y = _loc6_.y = 100;
         _loc5_.x = this.window.resizer.x + 2;
         _loc5_.y = this.window.resizer.y + 2;
         this.windowComponentsContainer.addElement(_loc2_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc1_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc4_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc5_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc3_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc6_,SimpleContainer.NO_ALIGN);
         this.addButtonsListeners();
      }
      
      private function addButtonsListeners() : void
      {
         this.repairButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleButtonOver);
         this.repairButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleButtonOut);
         this.fuelButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleButtonOver);
         this.fuelButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleButtonOut);
         this.playButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleButtonOver);
         this.playButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleButtonOut);
         this.stopButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleButtonOver);
         this.stopButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleButtonOut);
      }
      
      private function initInfoBars() : void
      {
         var _loc10_:BarComponent = null;
         var _loc11_:BarComponent = null;
         var _loc12_:BarComponent = null;
         var _loc13_:BarComponent = null;
         var _loc1_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_HP_BAR);
         var _loc2_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_XP_BAR);
         var _loc3_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_FUEL_BAR);
         var _loc4_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_SHIELD_BAR);
         var _loc5_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_PETNAME_TEXT);
         var _loc6_:SimpleElement = new SimpleElement(SimpleElement.PET_WINDOW_IMAGE_CONTAINER);
         var _loc7_:int = 0;
         var _loc8_:int = BORDER * 5;
         var _loc9_:int = BORDER * 6.5;
         _loc10_ = new BarComponent(barColors[_loc7_],this.barIcons[_loc7_]);
         _loc11_ = new BarComponent(barColors[++_loc7_],this.barIcons[_loc7_]);
         _loc13_ = new BarComponent(barColors[++_loc7_],this.barIcons[_loc7_]);
         _loc12_ = new BarComponent(barColors[++_loc7_],this.barIcons[_loc7_]);
         _loc1_.y = _loc8_;
         _loc1_.x = _loc9_;
         _loc4_.y = _loc8_ + BORDER * 2;
         _loc4_.x = _loc9_;
         _loc3_.y = _loc8_;
         _loc3_.x = _loc9_ + BORDER * 10.5;
         _loc2_.y = _loc8_ + BORDER * 2;
         _loc2_.x = _loc9_ + BORDER * 10.5;
         var _loc14_:TextFormat = Styles.logFmt;
         this.petNameTextfield = new TextField();
         this.petNameTextfield.antiAliasType = AntiAliasType.ADVANCED;
         this.petNameTextfield.autoSize = TextFieldAutoSize.LEFT;
         this.petNameTextfield.embedFonts = true;
         this.petNameTextfield.defaultTextFormat = _loc14_;
         this.petNameTextfield.setTextFormat(_loc14_);
         this.petNameTextfield.x = BORDER * 10;
         this.petNameTextfield.y = BORDER * 3;
         this.petNameTextfield.width = 140;
         _loc1_.addChild(_loc10_);
         _loc4_.addChild(_loc11_);
         _loc3_.addChild(_loc12_);
         _loc2_.addChild(_loc13_);
         _loc5_.addChild(this.petNameTextfield);
         var _loc15_:Sprite = new Sprite();
         _loc15_.buttonMode = _loc15_.useHandCursor = true;
         _loc6_.x = BORDER;
         _loc6_.y = BORDER * 4;
         _loc6_.addChild(_loc15_);
         this.addTooltip(_loc10_,"ttip_hitpoints");
         this.addTooltip(_loc11_,"ttip_shield");
         this.addTooltip(_loc13_,"ttip_experience");
         this.addTooltip(_loc12_,"ttip_fuel");
         this.addTooltip(_loc15_,"title_pet");
         this.windowComponentsContainer.addElement(_loc6_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc5_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc1_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc2_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc3_,SimpleContainer.NO_ALIGN);
         this.windowComponentsContainer.addElement(_loc4_,SimpleContainer.NO_ALIGN);
      }
      
      private function handleExpandButtonClick(param1:MouseEvent = null) : void
      {
         this.expandButton.removeEventListener(MouseEvent.CLICK,this.handleExpandButtonClick);
         this.toggleMovieClipState(this.expandButton);
         this.toggleCollapseWindow();
      }
      
      private function handleButtonOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.gotoAndStop(2);
      }
      
      private function handleButtonOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.gotoAndStop(1);
      }
      
      private function toggleCollapseWindow() : void
      {
         var _loc1_:int = 0;
         if(this.isCollapsed())
         {
            _loc1_ = -EXPANDED_WINDOW_HEIGHT;
         }
         else
         {
            _loc1_ = EXPANDED_WINDOW_HEIGHT;
            this.toggleCollapsableFrameVisibility(true);
         }
         TweenLite.to(this.window.resizer,1,{
            "y":this.window.resizer.y + _loc1_,
            "ease":Strong.easeInOut,
            "onUpdate":this.updateWindowExpansionHandler,
            "onComplete":this.completeWindowExpansionHandler
         });
      }
      
      private function updateWindowExpansionHandler() : void
      {
         this.window.checkSize();
         this.windowComponentsContainer.getElement(SimpleElement.PET_WINDOW_EXPAND_BTN).y = this.window.resizer.y + 2;
      }
      
      private function completeWindowExpansionHandler() : void
      {
         this.expandButton.addEventListener(MouseEvent.CLICK,this.handleExpandButtonClick);
         this.toggleCollapsableFrameVisibility(!this.isCollapsed());
      }
      
      private function toggleCollapsableFrameVisibility(param1:Boolean) : void
      {
         this.collapsableContainer.visible = param1;
      }
      
      private function toggleMovieClipState(param1:MovieClip) : void
      {
         var _loc2_:int = 1;
         if(param1.currentFrame == _loc2_)
         {
            _loc2_ = 2;
         }
         param1.gotoAndStop(_loc2_);
      }
      
      private function getAssets() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("window1"));
         this.windowIcon = _loc1_.getEmbededBitmap("pet.png");
         _loc1_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.playButton = _loc1_.getEmbededMovieClip("petPlayButton");
         this.stopButton = _loc1_.getEmbededMovieClip("petStopButton");
         this.fuelButton = _loc1_.getEmbededMovieClip("petFuelButton");
         this.expandButton = _loc1_.getEmbededMovieClip("expandButton");
         this.repairButton = _loc1_.getEmbededMovieClip("petRepairButton");
         this.barIcons = [_loc1_.getEmbededBitmap("hp_small.png"),_loc1_.getEmbededBitmap("shild_small.png"),_loc1_.getEmbededBitmap("xp_small.png"),_loc1_.getEmbededBitmap("fuel_small.png")];
      }
      
      private function addTooltip(param1:InteractiveObject, param2:String) : void
      {
         TooltipControl.getInstance().addToolTip(param1,BPLocale.getText(param2));
      }
      
      private function isCollapsed() : Boolean
      {
         return this.expandButton.currentFrame == 1;
      }
   }
}

