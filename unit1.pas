unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql56conn, sqldb, db, FileUtil, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, DbCtrls, Buttons,
  Unit4;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BT_Connect: TButton;
    BT_Insert: TButton;
    BT_Afficher: TButton;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MySQL56Connection1: TMySQL56Connection;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;

    SQLTransaction1: TSQLTransaction;
    procedure BitBtn1Click(Sender: TObject);
    procedure BT_ConnectClick(Sender: TObject);
    procedure BT_InsertClick(Sender: TObject);
    procedure BT_AfficherClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure SQLQuery1AfterDelete(DataSet: TDataSet);
    procedure SQLQuery1AfterPost(DataSet: TDataSet);
    procedure RefreshSQLQuery1 ();
    procedure RefreshCombobox1();

  private
    { private declarations }

  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BT_ConnectClick(Sender: TObject);
begin

  MySQL56Connection1.DatabaseName:='bibliotest';
  MySQL56Connection1.UserName:='root';
  // Tentative de connexion à la base de données bibliotest
  MySQL56Connection1.Open;
  if Not MySQL56Connection1.Connected then
    begin
     ShowMessage ('Connexion échouée !'); exit;
    end;
  Label1.Caption:='Connecté';
  // Affichage de la table auteurs dans le 1er DBGrid
   SQLQuery1.SQL.Text:= 'SELECT * FROM auteurs';
   SQLQuery1.Open;

   Combobox1.Items.Add('Tous');
   SQLQuery2.SQL.Text := 'SELECT DISTINCT nationalité FROM auteurs';
   SQLQuery2.Open;
   SQLQuery2.First;
   while(not SQLQuery2.EOF) do
     begin
      ComboBox1.Items.Add(SQLQuery2.Fields.Fields[0].AsString);
      SQLQuery2.Next;
     end;
   SQLQuery2.Close;

    SQLQuery2.Open;

  Datasource1.Dataset:=SQLQuery1;
  DBGrid1.DataSource:=DataSource1;
  SQLQuery1.Open;


end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Form4.Show;
end;

procedure TForm1.BT_InsertClick(Sender: TObject);

     var nom, prenom, nationalite, annee_naiss : string;
       begin

         nom := quotedstr(Edit1.Text);
         prenom := QuotedStr(Edit2.Text);
         nationalite := QuotedStr(Edit3.Text);
         annee_naiss := Edit4.Text;
         SQLTransaction1.commit;
         SQlTransaction1.StartTransaction;
         MySQL56Connection1.ExecuteDirect('insert into auteurs(nom,prénom,nationalité,année_naiss) values ('+nom+','+prenom+','+nationalite+','+annee_naiss+')');
         SQLTransaction1.Commit;

         RefreshSQLQuery1;
         RefreshCombobox1;
       end;

procedure TForm1.BT_AfficherClick(Sender: TObject);

       begin
           Edit5.Text := DBGrid1.Columns[0].Field.Text;
           Edit1.Text := DBGrid1.Columns[1].Field.Text;
           Edit2.Text := DBGrid1.Columns[2].Field.Text;
           Edit3.Text := DBGrid1.Columns[3].Field.Text;
           Edit4.Text := DBGrid1.Columns[4].Field.Text;


       end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin

end;

procedure TForm1.ComboBox1Select(Sender: TObject);
begin
  SQLQuery1.Close;
  if (Combobox1.Text='Tous') then
     SQLQuery1.SQL.Text:= 'SELECT * FROM auteurs'
  else
     SQLQuery1.SQL.Text:= 'SELECT * FROM auteurs WHERE nationalité="'+ComboBox1.Text+'"';
  SQLQuery1.Open;
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin

end;

procedure TForm1.Edit5Change(Sender: TObject);
begin

end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.Label2Click(Sender: TObject);
begin

end;

procedure TForm1.Label4Click(Sender: TObject);
begin

end;

procedure TForm1.SQLQuery1AfterDelete(DataSet: TDataSet);
begin
  SQLQuery1.applyupdates;
  SQLTransaction1.Commit;
  RefreshSQLQuery1;
  RefreshCombobox1;
end;

procedure TForm1.SQLQuery1AfterPost(DataSet: TDataSet);
begin
  SQLQuery1.applyupdates;
  SQLTransaction1.Commit;
  RefreshSQLQuery1;
  RefreshCombobox1;

end;

procedure TForm1.RefreshSQLQuery1 ();
  begin
   SQLQuery1.Close;
   SQLQuery1.SQL.Text:= 'SELECT * FROM auteurs';
   SQLQuery1.Open;
  end;

procedure TForm1.RefreshCombobox1();
  begin
   Combobox1.Items.Clear;;
   Combobox1.Items.Add('Tous');
   SQLQuery2.SQL.Text := 'SELECT DISTINCT nationalité FROM auteurs';
   SQLQuery2.Open;
   SQLQuery2.First;
   while(not SQLQuery2.EOF) do
     begin
      ComboBox1.Items.Add(SQLQuery2.Fields.Fields[0].AsString);
      SQLQuery2.Next;
     end;
   SQLQuery2.Close;

  end;


end.
