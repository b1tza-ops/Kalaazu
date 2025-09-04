package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.groupsystem.GroupMember;
   
   public class GroupMemberClip extends MovieClip
   {
      
      private static const logger:ILogger = Log.getLogger("GroupMemberClip");
      
      private var _member:GroupMember;
      
      private var _nickLabel:TextField;
      
      private var _nickName:String;
      
      private var _clanTag:String;
      
      private var _hpBar:MemberLiveBar;
      
      private var _shipType:int;
      
      private var _shipClip:ShipIcon;
      
      private var _shieldBar:MemberLiveBar;
      
      private var _mapID:int;
      
      private var _mapLabel:TextField;
      
      private var _cloakedState:Boolean;
      
      private var _isOffline:Boolean;
      
      private var _groupUi:GroupUI;
      
      private var _targetID:int;
      
      private var _targetObjectExists:Boolean;
      
      private var _targetClip:ShipIcon;
      
      private var _targetIconBG:Bitmap;
      
      private var _elementOffsetY:int = 0;
      
      private var _reservedHeight:int = 0;
      
      private var _leadIcon:Bitmap;
      
      private var _isLead:Boolean;
      
      private var _stdFormat:TextFormat;
      
      private var _foggyFormat:TextFormat;
      
      private var _inFight:Boolean;
      
      private var _shieldTooltip:ToolTipHook;
      
      private var _hpTooltip:ToolTipHook;
      
      private var _bg:Sprite;
      
      private var _fullClip:Sprite;
      
      private var _editingEnabled:Boolean;
      
      private var _targetingMemberEnabled:Boolean;
      
      private var _tooltipHitpointsBaseLabel:String;
      
      private var _tooltipShieldBaseLabel:String;
      
      public function GroupMemberClip()
      {
         super();
         this._bg = new Sprite();
         this._bg.addChild(new Bitmap(new BitmapData(216,40,true,0)));
         addChildAt(this._bg,0);
         this._mapLabel = new TextField();
         this._mapLabel.width = 24;
         this._mapLabel.y = 4;
         addChildAt(this._mapLabel,1);
         this._nickLabel = new TextField();
         this._nickLabel.x = 24;
         addChildAt(this._nickLabel,1);
         this._fullClip = new Sprite();
         this._fullClip.addChild(new Bitmap(new BitmapData(216,40,true,2298468096)));
         this.initStyles();
         this._elementOffsetY += Styles.simpleFontHeight + 6;
         this._reservedHeight = (Styles.simpleFontHeight + 10) * 2;
         this._tooltipHitpointsBaseLabel = BPLocale.getText("label_grp_hitpoints");
         this._tooltipShieldBaseLabel = BPLocale.getText("label_grp_shield");
      }
      
      public function disableEditing() : void
      {
         if(!this._editingEnabled)
         {
            return;
         }
         if(contains(this._fullClip))
         {
            removeChild(this._fullClip);
         }
         this._fullClip.removeEventListener(MouseEvent.CLICK,this.memberClickHandler);
         this._fullClip.removeEventListener(MouseEvent.MOUSE_OVER,this.memberRollOverHandler);
         this._fullClip.removeEventListener(MouseEvent.MOUSE_OUT,this.memberRollOutHandler);
         this._editingEnabled = false;
      }
      
      public function enableEditing() : void
      {
         if(this._editingEnabled)
         {
            return;
         }
         if(!contains(this._fullClip))
         {
            addChild(this._fullClip);
            this._fullClip.alpha = 0;
         }
         this._fullClip.addEventListener(MouseEvent.CLICK,this.memberClickHandler);
         this._fullClip.addEventListener(MouseEvent.MOUSE_OVER,this.memberRollOverHandler);
         this._fullClip.addEventListener(MouseEvent.MOUSE_OUT,this.memberRollOutHandler);
         this._editingEnabled = true;
      }
      
      public function dispose() : void
      {
      }
      
      private function initStyles() : void
      {
         this._stdFormat = new TextFormat(Styles.simpleFmt.font,Styles.simpleFontHeight);
         this._stdFormat.color = 16777215;
         this._foggyFormat = new TextFormat(Styles.simpleFmt.font,Styles.simpleFontHeight);
         this._foggyFormat.color = 10066329;
         this.setStyle(this._nickLabel,this._stdFormat,Styles.simpleEmbed);
         var _loc1_:TextFormat = new TextFormat(Styles.infoFieldFmt.font,Styles.infoFieldFontHeight);
         _loc1_.color = 10066329;
         _loc1_.align = TextFormatAlign.CENTER;
         this._mapLabel.height = Styles.infoFieldFontHeight + 6;
         this._mapLabel.embedFonts = Styles.infoFieldEmbed;
         this._mapLabel.defaultTextFormat = _loc1_;
         this._mapLabel.antiAliasType = AntiAliasType.ADVANCED;
         this._mapLabel.mouseEnabled = false;
         this._mapLabel.selectable = false;
      }
      
      private function setStyle(param1:TextField, param2:TextFormat, param3:Boolean) : void
      {
         param1.height = int(param2.size) + 6;
         param1.embedFonts = param3;
         param1.defaultTextFormat = param2;
         param1.antiAliasType = AntiAliasType.ADVANCED;
         param1.selectable = false;
      }
      
      private function disableTargetingTarget() : void
      {
      }
      
      private function enableTargetingTarget() : void
      {
      }
      
      public function update() : void
      {
         this.updateShip();
         this.updateNickLabel();
         this.updateMap();
         this.updateTarget();
         this.updateShield();
         this.updateHitpoints();
         this.updateLead();
      }
      
      private function updateShip() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(this._isOffline != this._member.isOffline)
         {
            this._isOffline = this._member.isOffline;
            _loc1_ = true;
            _loc2_ = true;
         }
         if(this._shipType != this._member.shipType)
         {
            this._shipType = this._member.shipType;
            _loc1_ = true;
            _loc2_ = true;
         }
         if(this._cloakedState != this._member.isCloaked)
         {
            this._cloakedState = this._member.isCloaked;
            _loc1_ = true;
         }
         if(this._inFight != this._member.fightState)
         {
            this._inFight = this._member.fightState;
            _loc1_ = true;
         }
         if(_loc1_)
         {
            this.getShipClip(_loc2_).cloaked = this._cloakedState;
            this.getShipClip().inFight = this._inFight;
         }
      }
      
      private function getShipClip(param1:Boolean = false) : ShipIcon
      {
         if(param1 && this._shipClip != null)
         {
            removeChild(this._shipClip);
            this._shipClip = null;
         }
         if(this._shipClip == null)
         {
            if(this._isOffline)
            {
               this._shipClip = new ShipIcon();
               this._shipClip.isOffline = this._member.isOffline;
               this._shipClip.baseGraphic = this._groupUi.getUiBitmap("disconnect_icon.png");
            }
            else
            {
               this._shipClip = this._groupUi.getShipIcon(this._member.shipType);
               this._shipClip.isOffline = this._member.isOffline;
            }
            this._shipClip.x = 4;
            this._shipClip.y = Styles.simpleFontHeight + 8;
            addChildAt(this._shipClip,1);
         }
         return this._shipClip;
      }
      
      private function updateTarget() : void
      {
         if(this._targetID != this._member.targetID)
         {
            this._targetID = this._member.targetID;
            if(this._targetID == 0 || this._targetID == -1)
            {
               if(this._targetClip != null && contains(this._targetClip))
               {
                  removeChild(this._targetClip);
               }
               this.disableTargetingTarget();
               this._targetClip = null;
               this._targetObjectExists = false;
            }
            else if(this._member.targetObject != null)
            {
               this._targetObjectExists = true;
               if(this._targetClip != null && contains(this._targetClip))
               {
                  removeChild(this._targetClip);
               }
               this._targetClip = this._groupUi.getShipIcon(this._member.targetObject.shipPatternID);
               addChildAt(this._targetClip,1);
               this._targetClip.x = this._targetIconBG.x;
               this._targetClip.y = this._targetIconBG.y;
               this.enableTargetingTarget();
            }
            else
            {
               if(this._targetClip != null && contains(this._targetClip))
               {
                  removeChild(this._targetClip);
               }
               this._targetClip = this._groupUi.getShipIcon(0);
               addChildAt(this._targetClip,1);
               this._targetClip.x = this._targetIconBG.x;
               this._targetClip.y = this._targetIconBG.y;
               this._targetObjectExists = false;
               this.disableTargetingTarget();
            }
         }
         else if(!this._targetObjectExists)
         {
            logger.fatal("->> todo updateTarget handle no target maybe redraw target, enable in case it");
         }
      }
      
      private function updateMap() : void
      {
         if(this._mapID != this._member.mapID)
         {
            this._mapID = this._member.mapID;
            this._mapLabel.text = InGameCatalog.instance.mapNames[this._mapID];
         }
         if(this._groupUi != null && this._mapID == this._groupUi.heroMap && !this._isOffline)
         {
            this._mapLabel.visible = false;
            this.getShipClip().foggy = false;
            this._nickLabel.defaultTextFormat = this._stdFormat;
            this.enableTargetingMember();
         }
         else
         {
            this._mapLabel.visible = true;
            this.getShipClip().foggy = true;
            this._nickLabel.defaultTextFormat = this._foggyFormat;
            this.disableTargetingMember();
         }
         this._nickLabel.setTextFormat(this._nickLabel.defaultTextFormat);
      }
      
      private function updateHitpoints() : void
      {
         if(this._member.hitPointsMax > 0 && !this._isOffline)
         {
            this._hpBar.liveValue = this._member.hitPointsCurrent / this._member.hitPointsMax;
         }
         else
         {
            this._hpBar.liveValue = 0;
         }
         this._hpTooltip.updateText(this._tooltipHitpointsBaseLabel + "\n" + BPLocale.roundInteger(this._member.hitPointsCurrent) + "|" + BPLocale.roundInteger(this._member.hitPointsMax));
      }
      
      private function updateShield() : void
      {
         if(this._member.shieldMax > 0 && !this._isOffline)
         {
            this._shieldBar.liveValue = this._member.shieldCurrent / this._member.shieldMax;
         }
         else
         {
            this._shieldBar.liveValue = 0;
         }
         this._shieldTooltip.updateText(this._tooltipShieldBaseLabel + "\n" + BPLocale.roundInteger(this._member.shieldCurrent) + "|" + BPLocale.roundInteger(this._member.shieldMax));
      }
      
      private function updateNickLabel() : void
      {
         this._nickLabel.mouseEnabled = true;
         if(this._clanTag != this._member.clanTag || this._nickName != this._member.nickName)
         {
            this._clanTag = this._member.clanTag;
            this._nickName = this._member.nickName;
            this._nickLabel.appendText(this._nickName);
         }
      }
      
      public function set groupUi(param1:GroupUI) : void
      {
         this._groupUi = param1;
         this.initMainGraphics();
      }
      
      private function initMainGraphics() : void
      {
         if(this._hpBar == null)
         {
            this._hpBar = new MemberLiveBar();
            this._hpBar.base = this._groupUi.getUiBitmap("empty_bar.png");
            this._hpBar.lightClip = this._groupUi.getUiBitmap("hp_bar.png");
            this._hpBar.x = this._nickLabel.x;
            this._hpBar.y = Styles.simpleFontHeight + 10;
            this._hpTooltip = TooltipControl.getInstance().addToolTip(this._hpBar,this._tooltipHitpointsBaseLabel);
            addChildAt(this._hpBar,1);
            this._shieldBar = new MemberLiveBar();
            this._shieldBar.base = this._groupUi.getUiBitmap("empty_bar.png");
            this._shieldBar.lightClip = this._groupUi.getUiBitmap("shield_bar.png");
            this._shieldBar.x = this._nickLabel.x;
            this._shieldBar.y = this._hpBar.y + 8;
            this._shieldTooltip = TooltipControl.getInstance().addToolTip(this._shieldBar,this._tooltipShieldBaseLabel);
            addChildAt(this._shieldBar,1);
            this._targetIconBG = this._groupUi.getUiBitmap("iconShipNull");
            addChildAt(this._targetIconBG,1);
            this._targetIconBG.x = this._nickLabel.x + 68;
            this._targetIconBG.y = Styles.simpleFontHeight + 8;
         }
      }
      
      public function cleanup() : void
      {
         this.disableTargetingMember();
         this.disableTargetingTarget();
      }
      
      private function enableTargetingMember() : void
      {
         if(this._targetingMemberEnabled)
         {
            return;
         }
         this._targetingMemberEnabled = true;
         this._nickLabel.mouseEnabled = this._targetingMemberEnabled;
         this._nickLabel.addEventListener(MouseEvent.CLICK,this.takeOverMemberClickHandler);
         this.getShipClip().addEventListener(MouseEvent.CLICK,this.takeOverMemberClickHandler);
      }
      
      private function disableTargetingMember() : void
      {
         if(!this._targetingMemberEnabled)
         {
            return;
         }
         this._targetingMemberEnabled = false;
         this._nickLabel.mouseEnabled = this._targetingMemberEnabled;
         this._nickLabel.removeEventListener(MouseEvent.CLICK,this.takeOverMemberClickHandler);
         this.getShipClip().removeEventListener(MouseEvent.CLICK,this.takeOverMemberClickHandler);
      }
      
      public function get reservedHeight() : int
      {
         return this._reservedHeight;
      }
      
      public function get isLead() : Boolean
      {
         return this._member.isLead;
      }
      
      private function updateLead() : void
      {
         if(this._isLead != this._member.isLead)
         {
            this._isLead = this._member.isLead;
            if(!this._isLead)
            {
               if(this._leadIcon != null && contains(this._leadIcon))
               {
                  removeChild(this._leadIcon);
               }
            }
            else
            {
               if(this._leadIcon == null)
               {
                  this._leadIcon = this._groupUi.getUiBitmap("boss_icon.png");
                  this._leadIcon.x = this._targetIconBG.x + this._targetIconBG.width + 4;
                  this._leadIcon.y = Styles.simpleFontHeight + 10;
               }
               if(!contains(this._leadIcon))
               {
                  addChildAt(this._leadIcon,1);
               }
            }
         }
      }
      
      public function get member() : GroupMember
      {
         return this._member;
      }
      
      public function set member(param1:GroupMember) : void
      {
         this._member = param1;
      }
      
      private function memberRollOutHandler(param1:MouseEvent = null) : void
      {
         TweenLite.to(this._fullClip,0.5,{"alpha":0});
      }
      
      private function memberRollOverHandler(param1:MouseEvent = null) : void
      {
         this._fullClip.alpha = 0;
         TweenLite.to(this._fullClip,0.5,{"alpha":1});
      }
      
      private function memberClickHandler(param1:MouseEvent = null) : void
      {
         this._groupUi.editMember(this._member);
      }
      
      private function takeOverMemberClickHandler(param1:MouseEvent = null) : void
      {
         if(this._groupUi != null)
         {
            this._groupUi.takeOverMemberTarget(this._member.id);
         }
      }
   }
}

