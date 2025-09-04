package net.bigpoint.darkorbit.questfm
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class QuestTree extends SimpleContainer
   {
      
      private static const logger:ILogger = Log.getLogger("QuestTree");
      
      public var quest:Quest;
      
      private var headlineLabel:TextField;
      
      private var contentRoot:MovieClip;
      
      private var runningBranchFormat:TextFormat;
      
      private var accomplishedBranchFormat:TextFormat;
      
      private var upcomingBranchFormat:TextFormat;
      
      private var branchOffset:int;
      
      private var elementDepthOffset:int;
      
      private var conditionBranches:Array = [];
      
      private var caseBranches:Array = [];
      
      private var allBranches:Array = [];
      
      private var branchesValues:Array = [];
      
      private var branchOffsetStart:Number;
      
      private var defaultInfoClip:MovieClip;
      
      private var defaultInfoClickArea:Sprite;
      
      private var questAssetsLib:SWFFinisher;
      
      private var iconsLib:SWFFinisher;
      
      public function QuestTree(param1:Main)
      {
         super(param1.getGuiManager(),SimpleContainer.CLASS_QUEST_TREE);
         guiManager = param1.getGuiManager();
         this.initFormat();
         this.initDefault();
         this.questAssetsLib = SWFFinisher(ResourceManager.fileCollection.getFinisher("questSystem"));
         this.iconsLib = SWFFinisher(ResourceManager.fileCollection.getFinisher("icons"));
      }
      
      private function initDefault() : void
      {
         this.defaultInfoClip = new MovieClip();
         var _loc1_:TextFormat = new TextFormat(Styles.strongStdFmt.font,Styles.strongStdFmt.size,15327936);
         var _loc2_:TextField = new TextField();
         _loc2_.defaultTextFormat = _loc1_;
         _loc2_.embedFonts = Styles.strongStdEmbed;
         _loc2_.antiAliasType = AntiAliasType.ADVANCED;
         _loc2_.mouseEnabled = true;
         _loc2_.selectable = false;
         _loc2_.multiline = true;
         _loc2_.wordWrap = true;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.width = 164;
         _loc2_.x = 8;
         _loc2_.y = 8;
         _loc2_.text = BPLocale.getText("msg_no_quest_running");
         this.defaultInfoClip.addChild(_loc2_);
         var _loc3_:TextField = new TextField();
         _loc3_.defaultTextFormat = _loc1_;
         _loc3_.embedFonts = Styles.strongStdEmbed;
         _loc3_.antiAliasType = AntiAliasType.ADVANCED;
         _loc3_.mouseEnabled = false;
         _loc3_.selectable = false;
         _loc3_.multiline = true;
         _loc3_.wordWrap = true;
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.width = _loc2_.width;
         _loc3_.x = _loc2_.x;
         _loc3_.y = _loc2_.y + _loc2_.height + 8;
         _loc3_.text = BPLocale.getText("msg_accept_jobs_here");
         this.defaultInfoClip.addChild(_loc3_);
         this.defaultInfoClickArea = new Sprite();
         this.defaultInfoClickArea.addChild(new Bitmap(new BitmapData(100,100,true,16711935)));
         this.defaultInfoClickArea.x = _loc3_.x;
         this.defaultInfoClickArea.y = _loc3_.y;
         this.defaultInfoClickArea.width = _loc3_.width;
         this.defaultInfoClickArea.height = _loc3_.height;
         this.defaultInfoClickArea.buttonMode = true;
         this.defaultInfoClip.addChild(this.defaultInfoClickArea);
         this.defaultInfoClickArea.addEventListener(MouseEvent.CLICK,this.handleMouseClickOnInfoTextField);
      }
      
      public function set isDefaultVisible(param1:Boolean) : void
      {
         if(param1 && !contains(this.defaultInfoClip))
         {
            addChild(this.defaultInfoClip);
            guiManager.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM).setDimension(width,height + 24);
         }
         else if(!param1 && contains(this.defaultInfoClip))
         {
            removeChild(this.defaultInfoClip);
         }
      }
      
      public function get isDefaultVisible() : Boolean
      {
         return contains(this.defaultInfoClip);
      }
      
      private function handleMouseClickOnInfoTextField(param1:MouseEvent) : void
      {
         var questLink:String = null;
         var event:MouseEvent = param1;
         questLink = Main.gameXML.tradeWindow.weblinks2.link.(@type == "2").@url;
         if(ExternalInterface.available)
         {
            ExternalInterface.call("referToURL",Settings.dynamicHost + questLink);
         }
      }
      
      public function showDefaultText(param1:String) : void
      {
         this.initHeadLine();
         this.headlineLabel.text = param1;
      }
      
      public function updateQuestTitle() : void
      {
         var _loc1_:Boolean = false;
         if(this.contentRoot.contains(this.headlineLabel))
         {
            _loc1_ = BPLocale.distillAndWrite(this.quest.title,this.headlineLabel);
            if(_loc1_)
            {
               TooltipControl.getInstance().addToolTip(this.headlineLabel,this.quest.title);
            }
         }
      }
      
      public function clearContent() : void
      {
         if(this.contentRoot != null)
         {
            if(contains(this.contentRoot))
            {
               removeChild(this.contentRoot);
            }
         }
         this.conditionBranches = [];
         this.caseBranches = [];
         this.allBranches = [];
         this.branchOffsetStart = 4;
         this.elementDepthOffset = 4;
         this.contentRoot = new MovieClip();
         addChild(this.contentRoot);
      }
      
      public function updateCondition(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ICondition = null;
         var _loc2_:QuestTreeBranch = QuestTreeBranch(this.conditionBranches[param1]);
         var _loc3_:ICondition = ICondition(_loc2_.questBaseObject);
         _loc2_.valuesLabel.text = _loc3_.currentVerbose + _loc3_.targetVerbose;
         if(_loc3_.runstate != _loc2_.runstate || _loc3_.visibility != _loc2_.visibility)
         {
            if(_loc3_.runstate)
            {
               _loc2_.uiClip.state = QuestTreeUIClip.RUNNING;
               _loc2_.descriptionLabel.defaultTextFormat = this.runningBranchFormat;
            }
            else if(_loc3_.visibility == 2)
            {
               _loc2_.uiClip.state = QuestTreeUIClip.COMPLETED;
               _loc2_.descriptionLabel.defaultTextFormat = this.accomplishedBranchFormat;
            }
            else
            {
               _loc2_.uiClip.state = QuestTreeUIClip.UPCOMING;
               _loc2_.descriptionLabel.defaultTextFormat = this.upcomingBranchFormat;
            }
            _loc2_.valuesLabel.defaultTextFormat = _loc2_.descriptionLabel.defaultTextFormat;
            _loc2_.valuesLabel.text = _loc3_.currentVerbose + _loc3_.targetVerbose;
            _loc2_.descriptionLabel.text = _loc3_.description;
            if(_loc3_.children.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.children.length)
               {
                  _loc5_ = ICondition(_loc3_.children[_loc4_]);
                  this.updateCondition(_loc5_.id);
                  _loc4_++;
               }
            }
         }
      }
      
      public function setSize(param1:int, param2:int) : void
      {
      }
      
      private function initFormat() : void
      {
         this.runningBranchFormat = new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFmt.size,15327936);
         this.accomplishedBranchFormat = new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFmt.size,8969608);
         this.upcomingBranchFormat = new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFmt.size,12169872);
      }
      
      public function update() : void
      {
         this.clearContent();
         this.initHeadLine();
         this.branchOffsetStart += this.headlineLabel.height + 3;
         this.branchOffset = this.branchOffsetStart;
         this.createQuestBranchFromCase(this.quest.getCase(),0,true);
         this.isDefaultVisible = false;
      }
      
      private function initHeadLine() : void
      {
         var _loc1_:TextFormat = new TextFormat(Styles.strongStdFmt.font,Styles.strongStdFmt.size,15327936);
         this.headlineLabel = new TextField();
         this.headlineLabel.defaultTextFormat = _loc1_;
         this.headlineLabel.embedFonts = Styles.strongStdEmbed;
         this.headlineLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.headlineLabel.mouseEnabled = true;
         this.headlineLabel.selectable = false;
         this.headlineLabel.width = 200;
         this.contentRoot.addChild(this.headlineLabel);
         if(this.quest.title == "")
         {
            this.headlineLabel.text = "…";
         }
         else
         {
            this.updateQuestTitle();
         }
         this.headlineLabel.height = 18;
         this.headlineLabel.y = this.branchOffsetStart;
      }
      
      private function createQuestBranchFromCase(param1:Case, param2:int, param3:Boolean = false) : QuestTreeBranch
      {
         var _loc7_:MovieClip = null;
         var _loc8_:QuestTreeUIToggleButton = null;
         var _loc9_:TextField = null;
         var _loc10_:int = 0;
         var _loc11_:QuestTreeBranch = null;
         var _loc4_:QuestTreeBranch = new QuestTreeBranch(QuestTreeBranchType.CASE);
         _loc4_.visibility = param1.visibility;
         _loc4_.runstate = param1.active;
         var _loc5_:int = 0;
         var _loc6_:String = "";
         if(param1.ordered)
         {
            _loc5_ = 4;
            _loc7_ = this.getQuestUiElement("caseBox");
            _loc8_ = this.getQuestTreeToggleButton(QuestTreeBranchType.CASE);
            _loc8_.id = param1.id;
            _loc4_.setUi(_loc7_,_loc8_);
            _loc4_.questBaseObject = param1;
            _loc4_.expanded = param1.showLong;
            this.contentRoot.addChild(_loc7_);
            this.contentRoot.addChild(_loc8_);
            _loc7_.x = param2;
            _loc7_.y = this.branchOffset;
            _loc8_.x = _loc7_.x;
            _loc8_.y = _loc7_.y + 4;
            _loc8_.selected = !param1.showLong;
            _loc9_ = TextField(_loc7_["txtLabel"]);
            _loc9_.autoSize = TextFieldAutoSize.LEFT;
            _loc9_.multiline = true;
            _loc9_.width = 128;
            _loc9_.antiAliasType = AntiAliasType.ADVANCED;
            _loc9_.mouseEnabled = false;
            _loc9_.selectable = false;
            if(param1.active)
            {
               _loc8_.state = QuestTreeUIClip.RUNNING;
               _loc9_.defaultTextFormat = this.runningBranchFormat;
            }
            else
            {
               _loc8_.state = QuestTreeUIClip.UPCOMING;
               if(param1.visibility == 2)
               {
                  _loc8_.state = QuestTreeUIClip.COMPLETED;
                  _loc9_.defaultTextFormat = this.accomplishedBranchFormat;
               }
               else
               {
                  _loc8_.state = QuestTreeUIClip.UPCOMING;
                  _loc9_.defaultTextFormat = this.upcomingBranchFormat;
               }
            }
            _loc9_.text = BPLocale.getText("q2_condition_CASE_sequence");
            _loc9_.embedFonts = true;
            if(param1.children.length < 2)
            {
               _loc9_.visible = false;
            }
            this.branchOffset += _loc7_.height;
            this.caseBranches[param1.id] = _loc4_;
            this.allBranches.push(_loc4_);
         }
         else if(param1.mandatory_child_count != param1.mandatory_count)
         {
            _loc5_ = 4;
            _loc7_ = this.getQuestUiElement("caseBox");
            _loc8_ = this.getQuestTreeToggleButton(QuestTreeBranchType.CASE);
            _loc8_.id = param1.id;
            _loc4_.setUi(_loc7_,_loc8_);
            _loc4_.questBaseObject = param1;
            _loc4_.expanded = param1.showLong;
            this.caseBranches[param1.id] = _loc4_;
            this.allBranches.push(_loc4_);
            this.contentRoot.addChild(_loc7_);
            this.contentRoot.addChild(_loc8_);
            _loc7_.x = param2;
            _loc7_.y = this.branchOffset;
            _loc8_.x = _loc7_.x;
            _loc8_.y = _loc7_.y + 4;
            _loc8_.selected = !param1.showLong;
            _loc9_ = TextField(_loc7_["txtLabel"]);
            _loc9_.autoSize = TextFieldAutoSize.LEFT;
            _loc9_.multiline = true;
            _loc9_.width = 128;
            _loc9_.embedFonts = true;
            _loc9_.antiAliasType = AntiAliasType.ADVANCED;
            _loc9_.mouseEnabled = false;
            _loc9_.selectable = false;
            if(param1.active)
            {
               _loc8_.state = QuestTreeUIClip.RUNNING;
               _loc9_.defaultTextFormat = this.runningBranchFormat;
            }
            else
            {
               _loc8_.state = QuestTreeUIClip.UPCOMING;
               if(param1.visibility == 2)
               {
                  _loc8_.state = QuestTreeUIClip.COMPLETED;
                  _loc9_.defaultTextFormat = this.accomplishedBranchFormat;
               }
               else
               {
                  _loc8_.state = QuestTreeUIClip.UPCOMING;
                  _loc9_.defaultTextFormat = this.upcomingBranchFormat;
               }
            }
            _loc6_ = BPLocale.getText("q2_condition_CASE_mandatory");
            _loc6_ = _loc6_.replace(/%count%/,param1.mandatory_count);
            _loc9_.text = _loc6_;
            this.branchOffset += _loc7_.height;
         }
         _loc4_.visible = param3;
         if(param3 && !param1.showLong)
         {
            param3 = false;
         }
         if(param1.children.length > 0)
         {
            _loc10_ = 0;
            while(_loc10_ < param1.children.length)
            {
               if(param1.children[_loc10_] is ICase)
               {
                  _loc11_ = this.createQuestBranchFromCase(param1.children[_loc10_],param2 + _loc5_,param3);
               }
               else
               {
                  _loc11_ = this.createQuestBranchFromCondition(param1.children[_loc10_],param2 + _loc5_);
                  this.displayCondition(_loc11_,param3);
               }
               if(!param1.showLong || !param3)
               {
                  this.branchOffset -= _loc11_.descriptionClip.height;
               }
               _loc10_++;
            }
            if(_loc8_ != null)
            {
               _loc8_.addEventListener(MouseEvent.CLICK,this.toggleCaseBranch);
            }
         }
         return _loc4_;
      }
      
      private function createQuestBranchFromCondition(param1:ICondition, param2:int) : QuestTreeBranch
      {
         var _loc4_:IQuestTreeUIClip = null;
         var _loc7_:MovieClip = null;
         var _loc11_:int = 0;
         var _loc12_:QuestTreeBranch = null;
         var _loc3_:MovieClip = this.getQuestUiElement("condBox");
         if(param1.children.length > 0)
         {
            _loc4_ = this.getQuestTreeToggleButton(QuestTreeBranchType.CONDITION);
            _loc4_.id = param1.id;
            QuestTreeUIToggleButton(_loc4_).selected = !param1.showLong;
         }
         else
         {
            _loc4_ = this.getConditionIcon(param1);
         }
         var _loc5_:Class = Class(Object(_loc4_).constructor);
         var _loc6_:MovieClip = this.getQuestUiElement("condValuesBox");
         if(param1.helpIconsClipIds != null)
         {
            _loc7_ = this.getIconClip(param1.helpIconsClipIds[0]);
         }
         var _loc8_:QuestTreeBranch = new QuestTreeBranch(QuestTreeBranchType.CONDITION);
         _loc8_.setUi(_loc3_,_loc4_,_loc6_,_loc7_);
         _loc8_.questBaseObject = param1;
         _loc8_.expanded = param1.showLong;
         _loc8_.visibility = param1.visibility;
         _loc8_.runstate = param1.runstate;
         this.conditionBranches[param1.id] = _loc8_;
         this.allBranches.push(_loc8_);
         this.contentRoot.addChild(_loc3_);
         this.contentRoot.addChild(_loc5_(_loc4_));
         this.branchesValues[param1.id] = _loc6_;
         this.contentRoot.addChild(_loc6_);
         _loc3_.x = param2;
         _loc3_.y = this.branchOffset;
         _loc5_(_loc4_).x = _loc3_.x;
         _loc5_(_loc4_).y = _loc3_.y + 4;
         _loc6_.x = 250;
         _loc6_.y = _loc3_.y;
         var _loc9_:TextField = TextField(_loc3_["txtLabel"]);
         _loc9_.autoSize = TextFieldAutoSize.LEFT;
         _loc9_.multiline = true;
         if(param1.helpIconsClipIds != null)
         {
            _loc9_.width = 114;
            this.contentRoot.addChild(_loc7_);
            _loc7_.x = _loc9_.x + _loc9_.width + 8;
            _loc7_.y = _loc3_.y;
         }
         else
         {
            _loc9_.width = 136;
         }
         _loc9_.embedFonts = true;
         _loc9_.antiAliasType = AntiAliasType.ADVANCED;
         _loc9_.mouseEnabled = false;
         _loc9_.selectable = false;
         var _loc10_:TextField = TextField(_loc6_["txtLabel"]);
         _loc10_.autoSize = TextFieldAutoSize.RIGHT;
         _loc10_.embedFonts = true;
         _loc10_.antiAliasType = AntiAliasType.ADVANCED;
         _loc10_.mouseEnabled = false;
         _loc10_.selectable = false;
         if(param1.runstate)
         {
            _loc4_.state = QuestTreeUIClip.RUNNING;
            _loc9_.defaultTextFormat = this.runningBranchFormat;
         }
         else if(param1.visibility == 2)
         {
            _loc4_.state = QuestTreeUIClip.COMPLETED;
            _loc9_.defaultTextFormat = this.accomplishedBranchFormat;
         }
         else
         {
            _loc4_.state = QuestTreeUIClip.UPCOMING;
            _loc9_.defaultTextFormat = this.upcomingBranchFormat;
         }
         _loc10_.defaultTextFormat = _loc9_.defaultTextFormat;
         _loc10_.text = param1.currentVerbose + param1.targetVerbose;
         _loc9_.text = param1.description;
         this.branchOffset += _loc3_.height;
         if(param1.children.length > 0)
         {
            _loc11_ = 0;
            while(_loc11_ < param1.children.length)
            {
               if(param1.children[_loc11_] != null)
               {
                  _loc12_ = this.createQuestBranchFromCondition(param1.children[_loc11_],param2 + 4);
                  this.displayCondition(_loc12_,param1.showLong);
                  if(!param1.showLong)
                  {
                     this.branchOffset -= _loc12_.descriptionClip.height;
                  }
               }
               _loc11_++;
            }
            _loc5_(_loc4_).addEventListener(MouseEvent.CLICK,this.toggleConditionBranch);
         }
         return _loc8_;
      }
      
      private function getIconClip(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = new MovieClip();
         _loc2_.addChild(new Bitmap(this.iconsLib.getEmbededBitmapData(param1)));
         return _loc2_;
      }
      
      private function toggleConditionBranch(param1:MouseEvent) : void
      {
         var _loc2_:IQuestTreeUIClip = IQuestTreeUIClip(param1.target);
         var _loc3_:QuestTreeBranch = QuestTreeBranch(this.conditionBranches[_loc2_.id]);
         QuestTreeUIToggleButton(_loc3_.uiClip).selected = _loc3_.expanded;
         _loc3_.expanded = !_loc3_.expanded;
         _loc3_.questBaseObject.showLong = _loc3_.expanded;
         var _loc4_:ICondition = ICondition(_loc3_.questBaseObject);
         this.displayChildren(_loc4_.children,_loc3_.expanded && Boolean(_loc4_.showLong));
         this.updateBranches();
      }
      
      private function displayCondition(param1:QuestTreeBranch, param2:Boolean) : void
      {
         param1.visible = param2;
      }
      
      private function displayChildren(param1:Array, param2:Boolean) : void
      {
         var _loc3_:ICondition = null;
         var _loc4_:Case = null;
         var _loc5_:QuestTreeBranch = null;
         var _loc6_:String = null;
         for(_loc6_ in param1)
         {
            if(param1[_loc6_] is ICondition)
            {
               _loc3_ = param1[_loc6_];
               _loc4_ = null;
            }
            else if(param1[_loc6_] is ICase)
            {
               _loc3_ = null;
               _loc4_ = param1[_loc6_];
            }
            if(_loc3_ != null && this.conditionBranches[_loc3_.id] != null)
            {
               _loc5_ = this.conditionBranches[_loc3_.id];
               this.displayCondition(_loc5_,param2);
            }
            if(_loc4_ != null && this.caseBranches[_loc4_.id] != null)
            {
               _loc5_ = QuestTreeBranch(this.caseBranches[_loc4_.id]);
               _loc5_.visible = param2;
               this.displayChildren(_loc4_.children,param2 && _loc5_.expanded);
            }
         }
      }
      
      private function toggleCaseBranch(param1:MouseEvent) : void
      {
         var _loc6_:String = null;
         var _loc7_:Case = null;
         var _loc8_:ICondition = null;
         var _loc2_:IQuestTreeUIClip = IQuestTreeUIClip(param1.target);
         var _loc3_:QuestTreeBranch = QuestTreeBranch(this.caseBranches[_loc2_.id]);
         var _loc4_:Case = Case(_loc3_.questBaseObject);
         QuestTreeUIToggleButton(_loc3_.uiClip).selected = _loc3_.expanded;
         _loc3_.expanded = !_loc3_.expanded;
         _loc3_.questBaseObject.showLong = _loc3_.expanded;
         var _loc5_:Array = _loc4_.children;
         for(_loc6_ in _loc5_)
         {
            if(_loc5_[_loc6_] is ICase)
            {
               _loc7_ = Case(_loc5_[_loc6_]);
               QuestTreeBranch(this.caseBranches[_loc7_.id]).visible = _loc3_.expanded;
               this.displayChildren(_loc7_.children,_loc3_.expanded && _loc7_.showLong);
            }
            else
            {
               _loc8_ = ICondition(_loc5_[_loc6_]);
               QuestTreeBranch(this.conditionBranches[_loc8_.id]).visible = _loc3_.expanded;
               this.displayChildren(_loc8_.children,_loc3_.expanded && Boolean(_loc8_.showLong));
            }
         }
         this.updateBranches();
      }
      
      public function updateBranches() : void
      {
         var _loc2_:QuestTreeBranch = null;
         this.branchOffset = this.branchOffsetStart;
         var _loc1_:int = 0;
         while(_loc1_ < this.allBranches.length)
         {
            _loc2_ = this.allBranches[_loc1_] as QuestTreeBranch;
            if(_loc2_.visible)
            {
               _loc2_.descriptionClip.y = this.branchOffset;
               MovieClip(_loc2_.uiClip).y = this.branchOffset + 4;
               if(_loc2_.valuesClip != null)
               {
                  _loc2_.valuesClip.y = this.branchOffset;
               }
               if(_loc2_.iconsClip != null)
               {
                  _loc2_.iconsClip.y = this.branchOffset;
               }
               this.branchOffset += _loc2_.descriptionClip.height;
            }
            _loc1_++;
         }
         guiManager.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM).dispatchEvent(new Event(SimpleWindow.ON_RESIZE));
      }
      
      private function getConditionIcon(param1:ICondition) : QuestTreeUIClip
      {
         var _loc2_:String = null;
         if(!param1.definition.VALIDATABLE)
         {
            _loc2_ = "failable_subcon";
         }
         else if(param1.children.length > 0)
         {
            _loc2_ = "casecon_open";
         }
         else if(param1.isSubcondition())
         {
            _loc2_ = "subcondition";
         }
         else
         {
            _loc2_ = "condition";
         }
         return this.getQuestTreeElement(_loc2_);
      }
      
      private function getQuestUiElement(param1:String) : MovieClip
      {
         return this.questAssetsLib.getEmbededMovieClip(param1);
      }
      
      private function getQuestTreeToggleButton(param1:int = 1) : QuestTreeUIToggleButton
      {
         var _loc5_:BitmapData = null;
         var _loc6_:BitmapData = null;
         var _loc7_:BitmapData = null;
         var _loc2_:String = "casecon_open";
         var _loc3_:String = "casecon_closed";
         var _loc4_:String = _loc2_;
         _loc5_ = this.questAssetsLib.getEmbededBitmapData(_loc4_ + "_running.gif");
         _loc6_ = this.questAssetsLib.getEmbededBitmapData(_loc4_ + "_upcoming.gif");
         _loc7_ = this.questAssetsLib.getEmbededBitmapData(_loc4_ + "_completed.gif");
         var _loc8_:QuestTreeUIToggleButton = new QuestTreeUIToggleButton();
         _loc8_.init(_loc5_,_loc6_,_loc7_);
         _loc4_ = _loc3_;
         _loc5_ = this.questAssetsLib.getEmbededBitmapData(_loc4_ + "_running.gif");
         _loc6_ = this.questAssetsLib.getEmbededBitmapData(_loc4_ + "_upcoming.gif");
         _loc7_ = this.questAssetsLib.getEmbededBitmapData(_loc4_ + "_completed.gif");
         _loc8_.setToggleClips(_loc5_,_loc6_,_loc7_);
         return _loc8_;
      }
      
      private function getQuestTreeElement(param1:String) : QuestTreeUIClip
      {
         var _loc2_:BitmapData = this.questAssetsLib.getEmbededBitmapData(param1 + "_running.gif");
         var _loc3_:BitmapData = this.questAssetsLib.getEmbededBitmapData(param1 + "_upcoming.gif");
         var _loc4_:BitmapData = this.questAssetsLib.getEmbededBitmapData(param1 + "_completed.gif");
         var _loc5_:QuestTreeUIClip = new QuestTreeUIClip();
         _loc5_.init(_loc2_,_loc3_,_loc4_);
         _loc5_.state = QuestTreeUIClip.RUNNING;
         return _loc5_;
      }
      
      public function get visibleHeight() : int
      {
         return this.branchOffset;
      }
   }
}

