package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.groupsystem.GroupMember;
   
   public class InvitationClip extends MovieClip
   {
      
      public static const TYPE_INCOMING:int = 1;
      
      public static const TYPE_OUTGOING:int = 2;
      
      private var _nickLabel:TextField;
      
      private var _shipClip:ShipIcon;
      
      private var _acceptButton:GroupActionButton;
      
      private var _rejectButton:GroupActionButton;
      
      private var _revokeButton:GroupActionButton;
      
      private var _member:GroupMember;
      
      private var _lineFormat:TextFormat;
      
      private var _type:int;
      
      private var _memberID:int;
      
      private var _groupUi:GroupUI;
      
      private var _bg:Bitmap;
      
      public function InvitationClip()
      {
         super();
         this._bg = new Bitmap(new BitmapData(128,28,true,0));
         addChild(this._bg);
         this._lineFormat = new TextFormat(Styles.simpleFmt.font,Styles.simpleFontHeight,16777215);
         this._nickLabel = new TextField();
         this.formatLabel(this._nickLabel);
         this._nickLabel.width = 104;
         this._nickLabel.x = 24;
         this._nickLabel.y = 6;
         addChild(this._nickLabel);
      }
      
      private function formatLabel(param1:TextField) : void
      {
         param1.defaultTextFormat = this._lineFormat;
         param1.embedFonts = Styles.simpleEmbed;
         param1.height = Styles.simpleFontHeight + 6;
         param1.multiline = false;
         param1.selectable = false;
      }
      
      public function init(param1:GroupMember) : void
      {
         this._member = param1;
         this._memberID = this._member.id;
         this._nickLabel.text = param1.nickName;
         this.updateShipClip();
      }
      
      private function updateShipClip(param1:Boolean = false) : void
      {
         if(param1 && this._shipClip != null)
         {
            if(contains(this._shipClip))
            {
               removeChild(this._shipClip);
            }
            this._shipClip = null;
         }
         if(this._groupUi != null && this._member != null && this._shipClip == null)
         {
            this._shipClip = this._groupUi.getShipIcon(this._member.shipType);
            this._shipClip.y = 8;
            addChild(this._shipClip);
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         if(this._type != param1)
         {
            this._type = param1;
            if(this._type == TYPE_INCOMING)
            {
               this._acceptButton = this._groupUi.createGroupActionButton(GroupActionButton.TYPE_ACCEPT);
               this._acceptButton.x = this._nickLabel.x + this._nickLabel.width + 4;
               TooltipControl.getInstance().addToolTip(this._acceptButton,BPLocale.getText("label_grp_invitation_accept"));
               addChild(this._acceptButton);
               this._rejectButton = this._groupUi.createGroupActionButton(GroupActionButton.TYPE_REJECT);
               this._rejectButton.x = this._acceptButton.x + this._acceptButton.width + 4;
               TooltipControl.getInstance().addToolTip(this._rejectButton,BPLocale.getText("label_grp_invitation_reject"));
               addChild(this._rejectButton);
            }
            else if(this._type == TYPE_OUTGOING)
            {
               this._revokeButton = this._groupUi.createGroupActionButton(GroupActionButton.TYPE_REVOKE);
               this._revokeButton.x = this._nickLabel.x + this._nickLabel.width + 4;
               TooltipControl.getInstance().addToolTip(this._revokeButton,BPLocale.getText("label_grp_invitation_revoke"));
               addChild(this._revokeButton);
            }
         }
      }
      
      public function get acceptButton() : GroupActionButton
      {
         return this._acceptButton;
      }
      
      public function get rejectButton() : GroupActionButton
      {
         return this._rejectButton;
      }
      
      public function get revokeButton() : GroupActionButton
      {
         return this._revokeButton;
      }
      
      public function get memberID() : int
      {
         return this._memberID;
      }
      
      public function get groupUi() : GroupUI
      {
         return this._groupUi;
      }
      
      public function set groupUi(param1:GroupUI) : void
      {
         this._groupUi = param1;
         this.updateShipClip();
      }
   }
}

