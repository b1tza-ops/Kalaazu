package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import mx.utils.StringUtil;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.groupsystem.Group;
   import net.bigpoint.darkorbit.groupsystem.GroupMember;
   import net.bigpoint.darkorbit.groupsystem.Invitation;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ClientCommands;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.ShipPattern;
   
   public class GroupUI extends SimpleContainer
   {
      
      public static const MAX_INVITATION_COUNT:int = 4;
      
      public static const ELEMENT_START_Y:int = 0;
      
      public static const MAX_MEMBERS_COUNT:int = 5;
      
      private var main:Main;
      
      private var _group:Group;
      
      private var _inputFieldFormat:TextFormat = new TextFormat("_sans",12,8947848);
      
      private var _inviteButton:GroupActionButton;
      
      private var _candidateInputField:TextField;
      
      private var _membersUIList:MovieClip;
      
      private var _membersUIReferences:Object;
      
      private var _isInPingMode:Boolean;
      
      private var _managementUI:GroupManagementUI;
      
      private var _invitations:Array;
      
      private var _sentInvitations:Object;
      
      private var _receivedInvitations:Object;
      
      private var _invitationLines:Array;
      
      private var _elementOffsetY:int;
      
      private var _totalHeight:int;
      
      private var _invitationsBlocked:Boolean;
      
      private var _changeBlockInviationsButton:GroupActionButton;
      
      private var _disposed:Boolean;
      
      private var _acceptButtonReferences:Dictionary;
      
      private var _rejectButtonReferences:Dictionary;
      
      private var _revokeButtonReferences:Dictionary;
      
      private var _uiLibFinisher:SWFFinisher;
      
      private var _inFollowMode:Boolean;
      
      private var _inPromoteMode:Boolean;
      
      private var _inKickMode:Boolean;
      
      private var _isCandidateInputNewlyFocussed:Boolean;
      
      private var _parentWindow:SimpleWindow;
      
      private var shipIcons:Array;
      
      public function GroupUI(param1:Main)
      {
         super(param1.getGuiManager(),SimpleContainer.CLASS_GROUP_SYSTEM);
         this.main = param1;
         this._uiLibFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.initInvitationUI();
         this._invitations = [];
         this._invitationLines = [];
         this._sentInvitations = [];
         this._receivedInvitations = [];
         this._acceptButtonReferences = new Dictionary();
         this._rejectButtonReferences = new Dictionary();
         this._revokeButtonReferences = new Dictionary();
         this.update();
         this.initShipIconsMap();
      }
      
      private function initShipIconsMap() : void
      {
         var _loc2_:ShipPattern = null;
         this.shipIcons = [];
         var _loc1_:Array = PatternManager.shipPatterns;
         for each(_loc2_ in _loc1_)
         {
            this.shipIcons[_loc2_.getPatternID()] = _loc2_.iconClassID;
         }
      }
      
      private function initInvitationUI() : void
      {
         this._candidateInputField = new TextField();
         this._candidateInputField.x = 0;
         this._candidateInputField.y = 4;
         this._candidateInputField.height = int(this._inputFieldFormat.size) + 6;
         this._candidateInputField.width = 128;
         this._candidateInputField.defaultTextFormat = this._inputFieldFormat;
         this._candidateInputField.border = true;
         this._candidateInputField.borderColor = 8947848;
         this._candidateInputField.backgroundColor = 1155390941;
         this._candidateInputField.multiline = false;
         this._candidateInputField.type = TextFieldType.INPUT;
         this._candidateInputField.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         this._candidateInputField.addEventListener(MouseEvent.CLICK,this.handleMouseClickOnInput);
         this._candidateInputField.addEventListener(FocusEvent.FOCUS_IN,this.handleFocusIn);
         addChild(this._candidateInputField);
         this._inviteButton = this.createGroupActionButton(GroupActionButton.TYPE_INVITE);
         this._inviteButton.addEventListener(MouseEvent.CLICK,this.handleInviteBtnClick);
         this._inviteButton.x = this._candidateInputField.width + 4;
         addChild(this._inviteButton);
         TooltipControl.getInstance().addToolTip(this._inviteButton,BPLocale.getText("label_invite"));
         this.getChangeBlockInviationsButton();
      }
      
      private function handleFocusIn(param1:FocusEvent) : void
      {
         if(param1.target == this._candidateInputField)
         {
            this._isCandidateInputNewlyFocussed = true;
         }
         else
         {
            this._isCandidateInputNewlyFocussed = false;
         }
      }
      
      private function handleMouseClickOnInput(param1:Event) : void
      {
         if(param1.target == this._candidateInputField && this._isCandidateInputNewlyFocussed)
         {
            this._candidateInputField.setSelection(0,this._candidateInputField.text.length);
            this._isCandidateInputNewlyFocussed = false;
         }
      }
      
      public function isGroupMember(param1:int) : Boolean
      {
         return this._membersUIReferences[param1] != null;
      }
      
      public function changeBlockInvitationsState(param1:Boolean) : void
      {
         if(this._invitationsBlocked != param1 || this._disposed)
         {
            this._invitationsBlocked = param1;
            this.getChangeBlockInviationsButton();
            if(this._disposed)
            {
               this.update();
            }
         }
      }
      
      private function handleKeyDown(param1:KeyboardEvent = null) : void
      {
         var _loc2_:int = int(param1.keyCode);
         switch(_loc2_)
         {
            case Keyboard.ENTER:
               this.parseInputAndInvite();
         }
      }
      
      public function editMember(param1:GroupMember) : void
      {
         if(this._inKickMode)
         {
            this.main.getConnectionManager().sendCommand(ClientCommands.GROUPSYSTEM,[ClientCommands.GROUPSYSTEM_KICK,param1.id]);
            this.handleKickBtnToggle();
         }
         else if(this._isInPingMode)
         {
            this.main.getConnectionManager().sendCommand(ClientCommands.GROUPSYSTEM,[ClientCommands.GROUPSYSTEM_PING,ClientCommands.GROUPSYSTEM_PING_USER,param1.id]);
            this.handlePingBtnToggle();
         }
         else if(this._inFollowMode)
         {
            this.main.getConnectionManager().sendCommand(ClientCommands.GROUPSYSTEM,[ClientCommands.GROUPSYSTEM_FOLLOW,param1.id]);
            this.handleFollowBtnToggle();
         }
         else if(this._inPromoteMode)
         {
            this.main.getConnectionManager().sendCommand(ClientCommands.GROUPSYSTEM,[ClientCommands.GROUPSYSTEM_PROMOTE,param1.id]);
            this.handlePromoteBtnToggle();
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:GroupMemberClip = null;
         var _loc2_:Invitation = null;
         var _loc3_:MovieClip = null;
         for each(_loc1_ in this._membersUIReferences)
         {
            this.removeMemberClip(_loc1_.member.id);
         }
         this._group = null;
         for each(_loc2_ in this._sentInvitations)
         {
            this.removeInvitation(_loc2_.getCandidate().id,InvitationClip.TYPE_OUTGOING);
         }
         for each(_loc2_ in this._receivedInvitations)
         {
            this.removeInvitation(_loc2_.getInviter().id,InvitationClip.TYPE_INCOMING);
         }
         this.updateManagementUI(false);
         this.invalidateInvitationUI(false);
         _loc3_ = this.main.getGuiManager().getGlobalchat();
         if(_loc3_ != null)
         {
            _loc3_.leaveGroupRoom();
         }
         this._disposed = true;
      }
      
      public function getUiBitmap(param1:String) : Bitmap
      {
         return this._uiLibFinisher.getEmbededBitmap(param1);
      }
      
      public function get heroMap() : int
      {
         return this.main.screenManager.map.getMapID();
      }
      
      public function updateEditMode(param1:Boolean, param2:uint) : void
      {
         if(param1)
         {
            this.enableMemberEditing();
         }
         else
         {
            this.disableMemberEditing();
         }
      }
      
      private function enableMemberEditing() : void
      {
         var _loc3_:GroupMember = null;
         var _loc4_:GroupMemberClip = null;
         if(!this.isInGroup())
         {
            return;
         }
         var _loc1_:Array = this._group.members;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = GroupMember(_loc1_[_loc2_]);
            if(_loc3_.id != Hero.userID)
            {
               _loc4_ = this.getGroupMemberClip(_loc3_);
               _loc4_.enableEditing();
            }
            _loc2_++;
         }
      }
      
      private function disableMemberEditing() : void
      {
         var _loc3_:GroupMember = null;
         var _loc4_:GroupMemberClip = null;
         if(!this.isInGroup())
         {
            return;
         }
         this.getMembersListClip();
         var _loc1_:Array = this._group.members;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = GroupMember(_loc1_[_loc2_]);
            if(_loc3_.id != Hero.userID)
            {
               _loc4_ = this.getGroupMemberClip(_loc3_);
               _loc4_.disableEditing();
            }
            _loc2_++;
         }
      }
      
      public function handlePingBtnToggle(param1:MouseEvent = null) : void
      {
         this._isInPingMode = !this._isInPingMode;
         this._managementUI.editMode(this._isInPingMode,GroupActionButton.TYPE_PING);
      }
      
      public function handleKickBtnToggle(param1:MouseEvent = null) : void
      {
         this._inKickMode = !this._inKickMode;
         this._managementUI.editMode(this._inKickMode,GroupActionButton.TYPE_KICK);
      }
      
      public function handleLeaveBtnClick(param1:MouseEvent = null) : void
      {
         this.main.getConnectionManager().sendCommand(ServerCommands.GROUPSYSTEM,[ClientCommands.GROUPSYSTEM_LEAVE]);
      }
      
      public function handleChangeBlockInvitationsBtnClick(param1:MouseEvent = null) : void
      {
         this.main.getConnectionManager().sendCommand(ServerCommands.GROUPSYSTEM,[ClientCommands.GROUPSYSTEM_BLOCK_INVITATIONS]);
      }
      
      public function handleChangeInvitationBehaviorBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = Group.INVITATION_BEHAVIOR_BOSS_ONLY;
         if(this._group.invitationBehavior == Group.INVITATION_BEHAVIOR_BOSS_ONLY)
         {
            _loc2_ = Group.INVITATION_BEHAVIOR_FREE_FOR_ALL;
         }
         this.main.getConnectionManager().sendCommand(ServerCommands.GROUPSYSTEM,[ClientCommands.GROUPSYSTEM_SET_REMOTE,ClientCommands.GROUPSYSTEM_CHANGE_INVITATON_BEHAVIOUR,_loc2_]);
      }
      
      public function handlePromoteBtnToggle(param1:MouseEvent = null) : void
      {
         this._inPromoteMode = !this._inPromoteMode;
         this._managementUI.editMode(this._inPromoteMode,GroupActionButton.TYPE_PROMOTE);
      }
      
      public function handleFollowBtnToggle(param1:MouseEvent = null) : void
      {
         this._inFollowMode = !this._inFollowMode;
         this._managementUI.editMode(this._inFollowMode,GroupActionButton.TYPE_FOLLOW);
      }
      
      public function teleportToMember(param1:int) : void
      {
         this.main.getConnectionManager().sendCommand(ClientCommands.GROUPSYSTEM,[ClientCommands.TELEPORT,param1]);
      }
      
      public function setCanditate(param1:MapObject) : void
      {
         this._candidateInputField.text = param1.getUsername();
      }
      
      public function removeMemberClip(param1:int) : void
      {
         var _loc2_:GroupMemberClip = null;
         if(this._membersUIList != null)
         {
            _loc2_ = this._membersUIReferences[param1];
            if(_loc2_ != null)
            {
               if(this._membersUIList.contains(_loc2_))
               {
                  this._membersUIList.removeChild(_loc2_);
                  _loc2_.dispose();
                  delete this._membersUIReferences[param1];
               }
            }
         }
      }
      
      public function setGroup(param1:Group) : void
      {
         var _loc2_:String = null;
         if(param1 == null && this._membersUIReferences != null)
         {
            for(_loc2_ in this._membersUIReferences)
            {
               this.removeMemberClip(int(_loc2_));
            }
         }
         else
         {
            this._candidateInputField.text = "";
         }
         this._group = param1;
      }
      
      private function isInGroup() : Boolean
      {
         if(this._group != null && this._group.members.length > 0)
         {
            return true;
         }
         return false;
      }
      
      public function update() : void
      {
         this._elementOffsetY = ELEMENT_START_Y;
         if(this.isInGroup())
         {
            this.invalidateMembersList();
            if(this._invitations != null && this._invitations.length > 0)
            {
               this.invalidateInvitations();
            }
            this.invalidateInvitationUI();
            this.updateManagementUI(true);
            this._isInPingMode = false;
         }
         else
         {
            this.invalidateInvitationUI();
            if(this._invitations != null && this._invitations.length > 0)
            {
               this.invalidateInvitations();
            }
            this.updateManagementUI(false);
         }
         if(this._parentWindow != null && this._totalHeight != this._elementOffsetY)
         {
            this._totalHeight = this._elementOffsetY;
            this._parentWindow.setDimension(196,this._totalHeight + 24);
         }
         this._disposed = false;
      }
      
      private function updateManagementUI(param1:Boolean = false) : void
      {
         if(this._managementUI == null)
         {
            this._managementUI = new GroupManagementUI(this);
            addChild(this._managementUI);
         }
         this._managementUI.visible = param1;
         this._managementUI.group = this._group;
         this._managementUI.update(param1);
         this._managementUI.y = this._elementOffsetY;
         if(param1)
         {
            this._elementOffsetY += this._managementUI.height;
         }
      }
      
      private function invalidateInvitationUI(param1:Boolean = true) : void
      {
         var _loc2_:Boolean = false;
         var _loc4_:int = 0;
         var _loc3_:Boolean = param1 && !this.isInGroup();
         if(param1 && (!this.isInGroup() || this._group.heroIsBoss || this._group.invitationBehavior == Group.INVITATION_BEHAVIOR_FREE_FOR_ALL))
         {
            _loc4_ = int(this._invitations.length);
            if(this.isInGroup())
            {
               _loc4_ += this._group.members.length;
            }
            if(_loc4_ < MAX_MEMBERS_COUNT)
            {
               _loc2_ = true;
               this._candidateInputField.y = this._elementOffsetY + 4;
               this._inviteButton.y = this._elementOffsetY;
               this._changeBlockInviationsButton.y = this._elementOffsetY;
               this._elementOffsetY += 28;
            }
         }
         this._candidateInputField.visible = _loc2_;
         this._inviteButton.visible = _loc2_;
         this._changeBlockInviationsButton.visible = _loc3_;
      }
      
      private function invalidateMembersList() : void
      {
         var _loc4_:GroupMember = null;
         var _loc5_:GroupMemberClip = null;
         this.getMembersListClip();
         var _loc1_:Array = this._group.members;
         _loc1_.sortOn("orderID",Array.NUMERIC);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = GroupMember(_loc1_[_loc3_]);
            if(_loc4_.id != Hero.userID)
            {
               _loc5_ = this.getGroupMemberClip(_loc4_);
               _loc5_.update();
               _loc5_.y = _loc2_;
               _loc2_ += _loc5_.reservedHeight;
            }
            _loc3_++;
         }
         this._elementOffsetY += _loc2_;
      }
      
      private function getGroupMemberClip(param1:GroupMember) : GroupMemberClip
      {
         var _loc2_:GroupMemberClip = this._membersUIReferences[param1.id];
         if(_loc2_ == null)
         {
            _loc2_ = new GroupMemberClip();
            _loc2_.member = param1;
            _loc2_.groupUi = this;
            this._membersUIList.addChild(_loc2_);
            this._membersUIReferences[param1.id] = _loc2_;
         }
         return _loc2_;
      }
      
      private function getMembersListClip() : MovieClip
      {
         if(this._membersUIList == null)
         {
            this._membersUIList = new MovieClip();
            addChild(this._membersUIList);
            this._membersUIReferences = {};
         }
         this._membersUIList.y = ELEMENT_START_Y;
         this._elementOffsetY = 0;
         return this._membersUIList;
      }
      
      public function info(param1:String) : void
      {
      }
      
      private function handleInviteBtnClick(param1:MouseEvent) : void
      {
         this.parseInputAndInvite();
      }
      
      private function parseInputAndInvite() : void
      {
         var _loc2_:Array = null;
         var _loc1_:String = StringUtil.trim(this._candidateInputField.text);
         if(_loc1_ != "")
         {
            _loc2_ = [ServerCommands.GROUPSYSTEM_GROUP_INVITE,ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_BY_NAME,_loc1_];
            this.main.getConnectionManager().sendCommand(ServerCommands.GROUPSYSTEM,_loc2_);
            this._candidateInputField.text = "";
         }
      }
      
      public function takeOverMemberTarget(param1:int) : void
      {
         this.main.getConnectionManager().sendCommand(ClientCommands.SELECT_SHIP,[param1]);
      }
      
      public function get isInPingMode() : Boolean
      {
         return this._isInPingMode;
      }
      
      public function set isInPingMode(param1:Boolean) : void
      {
         this._isInPingMode = param1;
         this.updateEditMode(this._isInPingMode,GroupActionButton.TYPE_PING);
      }
      
      public function addInvitation(param1:Invitation) : void
      {
         this._invitations.push(param1);
         if(param1.getInviter().id == Hero.userID)
         {
            this._sentInvitations.push(param1);
         }
         else
         {
            this._receivedInvitations.push(param1);
            this.main.getGuiManager().writeToLog(BPLocale.getText("label_grp_inv_from").replace(/%name%/,param1.getInviter().nickName));
         }
      }
      
      public function deleteInvitations() : void
      {
         this._invitations = [];
         this._invitationLines = [];
         this._sentInvitations = [];
         this._receivedInvitations = [];
         this._acceptButtonReferences = new Dictionary();
         this._rejectButtonReferences = new Dictionary();
         this._revokeButtonReferences = new Dictionary();
      }
      
      private function invalidateInvitations() : void
      {
         var _loc1_:Invitation = null;
         var _loc2_:InvitationClip = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(this._invitations == null)
         {
            return;
         }
         for each(_loc1_ in this._invitations)
         {
            if(_loc1_.getInviter().id == Hero.userID)
            {
               _loc3_ = _loc1_.getCandidate().id;
               if(this._revokeButtonReferences[_loc3_] == null)
               {
                  _loc2_ = new InvitationClip();
                  _loc2_.groupUi = this;
                  _loc2_.init(_loc1_.getCandidate());
                  _loc2_.type = InvitationClip.TYPE_OUTGOING;
                  TooltipControl.getInstance().addToolTip(_loc2_,BPLocale.getText("label_grp_inv_for").replace(/%name%/,_loc1_.getCandidate().nickName));
                  _loc4_ = true;
               }
            }
            else
            {
               _loc3_ = _loc1_.getInviter().id;
               if(this._rejectButtonReferences[_loc3_] == null)
               {
                  _loc2_ = new InvitationClip();
                  _loc2_.groupUi = this;
                  _loc2_.init(_loc1_.getInviter());
                  _loc2_.type = InvitationClip.TYPE_INCOMING;
                  TooltipControl.getInstance().addToolTip(_loc2_,BPLocale.getText("label_grp_inv_from").replace(/%name%/,_loc1_.getInviter().nickName));
                  _loc4_ = true;
               }
            }
            if(_loc4_)
            {
               this.addListeners(_loc2_,_loc3_);
               addChild(_loc2_);
               this._invitationLines.push(_loc2_);
            }
         }
         for each(_loc2_ in this._invitationLines)
         {
            _loc2_.y = this._elementOffsetY;
            this._elementOffsetY += 28;
         }
      }
      
      private function addListeners(param1:InvitationClip, param2:int) : void
      {
         switch(param1.type)
         {
            case InvitationClip.TYPE_INCOMING:
               param1.rejectButton.addEventListener(MouseEvent.CLICK,this.rejectInvitationClicked);
               this._rejectButtonReferences[param2] = param1.rejectButton;
               param1.acceptButton.addEventListener(MouseEvent.CLICK,this.acceptInvitationClicked);
               this._acceptButtonReferences[param2] = param1.acceptButton;
               break;
            case InvitationClip.TYPE_OUTGOING:
               param1.revokeButton.addEventListener(MouseEvent.CLICK,this.revokeInvitationClicked);
               this._revokeButtonReferences[param2] = param1.revokeButton;
         }
      }
      
      private function revokeInvitationClicked(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:GroupActionButton = GroupActionButton(param1.target);
         for(_loc3_ in this._revokeButtonReferences)
         {
            if(GroupActionButton(this._revokeButtonReferences[_loc3_]) == _loc2_)
            {
               this.main.getConnectionManager().sendCommand(ServerCommands.GROUPSYSTEM,[ServerCommands.GROUPSYSTEM_GROUP_INVITE,ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_REVOKE,_loc3_]);
               this.disableInvitationUI(int(_loc3_),InvitationClip.TYPE_OUTGOING);
               break;
            }
         }
      }
      
      private function disableInvitationUI(param1:int, param2:int) : void
      {
         if(param2 == InvitationClip.TYPE_INCOMING)
         {
            if(this._acceptButtonReferences[param1] != null)
            {
               GroupActionButton(this._acceptButtonReferences[param1]).enabled = false;
            }
            if(this._rejectButtonReferences[param1] != null)
            {
               GroupActionButton(this._rejectButtonReferences[param1]).enabled = false;
            }
         }
         else if(this._revokeButtonReferences[param1] != null)
         {
            GroupActionButton(this._revokeButtonReferences[param1]).enabled = false;
         }
      }
      
      public function acceptInvitationClicked(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:GroupActionButton = GroupActionButton(param1.target);
         for(_loc3_ in this._acceptButtonReferences)
         {
            if(GroupActionButton(this._acceptButtonReferences[_loc3_]) == _loc2_)
            {
               this.main.getConnectionManager().sendCommand(ServerCommands.GROUPSYSTEM,[ServerCommands.GROUPSYSTEM_GROUP_INVITE,ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_ACKNOWLEDGE,_loc3_]);
               this.disableInvitationUI(int(_loc3_),InvitationClip.TYPE_INCOMING);
               break;
            }
         }
      }
      
      public function removeInvitation(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Invitation = null;
         var _loc5_:GroupActionButton = null;
         var _loc6_:GroupActionButton = null;
         if(param2 == InvitationClip.TYPE_INCOMING)
         {
            if(this._rejectButtonReferences[param1] == null)
            {
               return;
            }
            GroupActionButton(this._rejectButtonReferences[param1]).removeEventListener(MouseEvent.CLICK,this.rejectInvitationClicked);
            GroupActionButton(this._acceptButtonReferences[param1]).removeEventListener(MouseEvent.CLICK,this.acceptInvitationClicked);
            TooltipControl.getInstance().removeToolTip(GroupActionButton(this._rejectButtonReferences[param1]));
            TooltipControl.getInstance().removeToolTip(GroupActionButton(this._acceptButtonReferences[param1]));
            _loc3_ = 0;
            while(_loc3_ < this._invitations.length)
            {
               _loc4_ = Invitation(this._invitations[_loc3_]);
               if(_loc4_.getInviter().id == param1)
               {
                  this._invitations.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this._receivedInvitations.length)
            {
               _loc4_ = Invitation(this._receivedInvitations[_loc3_]);
               if(_loc4_.getInviter().id == param1)
               {
                  this._receivedInvitations.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this._invitationLines.length)
            {
               _loc5_ = InvitationClip(this._invitationLines[_loc3_]).acceptButton;
               if(_loc5_ == GroupActionButton(this._acceptButtonReferences[param1]))
               {
                  TooltipControl.getInstance().removeToolTip(InvitationClip(this._invitationLines[_loc3_]));
                  removeChild(InvitationClip(this._invitationLines[_loc3_]));
                  this._invitationLines.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            delete this._rejectButtonReferences[param1];
            delete this._acceptButtonReferences[param1];
         }
         else if(param2 == InvitationClip.TYPE_OUTGOING)
         {
            if(this._revokeButtonReferences[param1] == null)
            {
               return;
            }
            GroupActionButton(this._revokeButtonReferences[param1]).removeEventListener(MouseEvent.CLICK,this.revokeInvitationClicked);
            TooltipControl.getInstance().removeToolTip(GroupActionButton(this._revokeButtonReferences[param1]));
            _loc3_ = 0;
            while(_loc3_ < this._invitations.length)
            {
               _loc4_ = Invitation(this._invitations[_loc3_]);
               if(_loc4_.getCandidate().id == param1)
               {
                  this._invitations.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this._sentInvitations.length)
            {
               _loc4_ = Invitation(this._sentInvitations[_loc3_]);
               if(_loc4_ != null && _loc4_.getCandidate() != null && _loc4_.getCandidate().id == param1)
               {
                  this._sentInvitations.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this._invitationLines.length)
            {
               _loc6_ = InvitationClip(this._invitationLines[_loc3_]).revokeButton;
               if(_loc6_ == GroupActionButton(this._revokeButtonReferences[param1]))
               {
                  TooltipControl.getInstance().removeToolTip(InvitationClip(this._invitationLines[_loc3_]));
                  removeChild(InvitationClip(this._invitationLines[_loc3_]));
                  this._invitationLines.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
            delete this._revokeButtonReferences[param1];
         }
      }
      
      private function rejectInvitationClicked(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:GroupActionButton = GroupActionButton(param1.target);
         for(_loc3_ in this._rejectButtonReferences)
         {
            if(GroupActionButton(this._rejectButtonReferences[_loc3_]) == _loc2_)
            {
               this.main.getConnectionManager().sendCommand(ServerCommands.GROUPSYSTEM,[ServerCommands.GROUPSYSTEM_GROUP_INVITE,ServerCommands.GROUPSYSTEM_GROUP_INVITE_SUB_REJECT,_loc3_]);
               this.disableInvitationUI(int(_loc3_),InvitationClip.TYPE_INCOMING);
               break;
            }
         }
      }
      
      public function createGroupActionButton(param1:uint) : GroupActionButton
      {
         var _loc2_:GroupActionButton = new GroupActionButton();
         _loc2_.type = param1;
         var _loc3_:* = "btn_" + _loc2_.typeVerbose + "_";
         _loc2_.init(this._uiLibFinisher.getEmbededBitmapData(_loc3_ + "std.png"),this._uiLibFinisher.getEmbededBitmapData(_loc3_ + "mo.png"),this._uiLibFinisher.getEmbededBitmapData(_loc3_ + "da.png"));
         return _loc2_;
      }
      
      public function getShipIcon(param1:int) : ShipIcon
      {
         var _loc2_:ShipIcon = new ShipIcon();
         var _loc3_:int = int(this.shipIcons[param1]);
         _loc2_.baseGraphic = this._uiLibFinisher.getEmbededBitmap("iconShip" + _loc3_);
         return _loc2_;
      }
      
      private function getChangeBlockInviationsButton() : GroupActionButton
      {
         var _loc1_:String = null;
         if(this._invitationsBlocked)
         {
            if(this._changeBlockInviationsButton != null && this._changeBlockInviationsButton.type == GroupActionButton.TYPE_BLOCK_INVITATIONS)
            {
               TooltipControl.getInstance().removeToolTip(this._changeBlockInviationsButton);
               this._changeBlockInviationsButton.handleClick = null;
               if(contains(this._changeBlockInviationsButton))
               {
                  removeChild(this._changeBlockInviationsButton);
               }
               this._changeBlockInviationsButton = null;
            }
            if(this._changeBlockInviationsButton == null)
            {
               this._changeBlockInviationsButton = this.createGroupActionButton(GroupActionButton.TYPE_ALLOW_INVITATIONS);
               this._changeBlockInviationsButton.handleClick = this.handleChangeBlockInvitationsBtnClick;
            }
            _loc1_ = "label_grp_allow_invitations";
         }
         else
         {
            if(this._changeBlockInviationsButton != null && this._changeBlockInviationsButton.type == GroupActionButton.TYPE_ALLOW_INVITATIONS)
            {
               TooltipControl.getInstance().removeToolTip(this._changeBlockInviationsButton);
               this._changeBlockInviationsButton.handleClick = null;
               if(contains(this._changeBlockInviationsButton))
               {
                  removeChild(this._changeBlockInviationsButton);
               }
               this._changeBlockInviationsButton = null;
            }
            if(this._changeBlockInviationsButton == null)
            {
               this._changeBlockInviationsButton = this.createGroupActionButton(GroupActionButton.TYPE_BLOCK_INVITATIONS);
               this._changeBlockInviationsButton.handleClick = this.handleChangeBlockInvitationsBtnClick;
            }
            _loc1_ = "label_grp_block_invitations";
         }
         this._changeBlockInviationsButton.x = this._inviteButton.x + this._inviteButton.width + 4;
         this._changeBlockInviationsButton.y = this._inviteButton.y;
         if(!contains(this._changeBlockInviationsButton))
         {
            addChild(this._changeBlockInviationsButton);
         }
         TooltipControl.getInstance().removeToolTip(this._changeBlockInviationsButton);
         TooltipControl.getInstance().addToolTip(this._changeBlockInviationsButton,BPLocale.getText(_loc1_));
         return this._changeBlockInviationsButton;
      }
      
      public function get invitations() : Array
      {
         return this._invitations;
      }
      
      public function set invitations(param1:Array) : void
      {
         this._invitations = param1;
      }
      
      public function get sentInvitations() : Object
      {
         return this._sentInvitations;
      }
      
      public function set sentInvitations(param1:Object) : void
      {
         this._sentInvitations = param1;
      }
      
      public function get receivedInvitations() : Object
      {
         return this._receivedInvitations;
      }
      
      public function set receivedInvitations(param1:Object) : void
      {
         this._receivedInvitations = param1;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      public function set disposed(param1:Boolean) : void
      {
         this._disposed = param1;
      }
      
      public function get parentWindow() : SimpleWindow
      {
         return this._parentWindow;
      }
      
      public function set parentWindow(param1:SimpleWindow) : void
      {
         this._parentWindow = param1;
         this.update();
      }
   }
}

