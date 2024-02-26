unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql56conn, sqldb, db, FileUtil, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, DbCtrls, Buttons, ComCtrls;

type

  { TForm4 }

  TForm4 = class(TForm)
    BT_Afficher: TButton;
    BT_Insert: TButton;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
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
    procedure BT_AfficherClick(Sender: TObject);
    procedure BT_InsertClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure SQLQuery1AfterDelete(DataSet: TDataSet);
    procedure SQLQuery1AfterPost(DataSet: TDataSet);
    procedure RefreshSQLQuery1();
    procedure RefreshCombobox1();
  private

  public

  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.FormCreate(Sender: TObject);
begin

end;

procedure TForm4.BT_AfficherClick(Sender: TObject);
begin
    MySQL56Connection1.DatabaseName:='proprio';
  MySQL56Connection1.UserName:='root';
  // Tentative de connexion à la base de données proprio
  MySQL56Connection1.Open;
  if Not MySQL56Connection1.Connected then
    begin
     ShowMessage ('Connexion échouée !'); exit;
    end;
  // Affichage de la table proprietaire dans le 1er DBGrid
   SQLQuery1.SQL.Text:= 'SELECT * FROM proprietaire';
   SQLQuery1.Open;

   Combobox1.Items.Add('Tous');
   SQLQuery2.SQL.Text := 'SELECT DISTINCT domicile FROM proprietaire';
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

procedure TForm4.BT_InsertClick(Sender: TObject);

var nom, prenom, domicile, annee_naiss : string;
       begin

         nom := quotedstr(Edit1.Text);
         prenom := QuotedStr(Edit2.Text);
         domicile := QuotedStr(Edit3.Text);
         annee_naiss := Edit4.Text;
         SQLTransaction1.commit;
         SQlTransaction1.StartTransaction;
         MySQL56Connection1.ExecuteDirect('insert into proprietaire(nom,prénom,domicile,année_naiss) values ('+nom+','+prenom+','+domicile+','+annee_naiss+')');
         SQLTransaction1.Commit;

         RefreshSQLQuery1;
         RefreshCombobox1;
         end;


procedure TForm4.ComboBox1Change(Sender: TObject);
begin

end;

procedure TForm4.ComboBox1Select(Sender: TObject);
begin
  SQLQuery1.Close;
  if (Combobox1.Text='Tous') then
     SQLQuery1.SQL.Text:= 'SELECT * FROM proprietaire'
  else
     SQLQuery1.SQL.Text:= 'SELECT * FROM proprietaire WHERE domicile="'+ComboBox1.Text+'"';
  SQLQuery1.Open;

end;

procedure TForm4.Label6Click(Sender: TObject);
begin

end;

procedure TForm4.Label7Click(Sender: TObject);
begin

end;

procedure Tform4.SQLQuery1AfterDelete(DataSet: TDataSet);
begin
  SQLQuery1.applyupdates;
  SQLTransaction1.Commit;
  RefreshSQLQuery1;
  RefreshCombobox1;
end;

procedure TForm4.SQLQuery1AfterPost(DataSet: TDataSet);
begin
  SQLQuery1.applyupdates;
  SQLTransaction1.Commit;
  RefreshSQLQuery1;
  RefreshCombobox1;

end;

procedure TForm4.RefreshSQLQuery1();
  begin
   SQLQuery1.Close;
   SQLQuery1.SQL.Text:= 'SELECT * FROM proprietaire';
   SQLQuery1.Open;
  end;

procedure TForm4.RefreshCombobox1();
  begin
   Combobox1.Items.Clear;
   Combobox1.Items.Add('Tous');
   SQLQuery2.SQL.Text := 'SELECT DISTINCT domicile FROM proprietaire';
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

