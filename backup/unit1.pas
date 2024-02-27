unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql56conn, sqldb, db, FileUtil, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, DbCtrls, Buttons, ComCtrls, ExtCtrls,
  Unit4;

type

  { TForm1 }

  TForm1 = class(TForm)
    BT_Afficher1: TButton;
    BT_Connect: TButton;
    BT_Insert: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MySQL56Connection1: TMySQL56Connection;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLQuery3: TSQLQuery;

    SQLTransaction1: TSQLTransaction;
    procedure BitBtn1Click(Sender: TObject);
    procedure BT_ConnectClick(Sender: TObject);
    procedure BT_InsertClick(Sender: TObject);
    procedure BT_AfficherClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure SQLQuery1AfterDelete(DataSet: TDataSet);
    procedure SQLQuery1AfterPost(DataSet: TDataSet);
    procedure RefreshSQLQuery1();
    procedure RefreshCombobox1();

    procedure isEditEmptyForAdding;
    procedure isEditEmptyForDelete;

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

  MySQL56Connection1.DatabaseName:='proprio';
  MySQL56Connection1.UserName:='root';
  // Tentative de connexion à la base de données proprio
  MySQL56Connection1.Open;
  if Not MySQL56Connection1.Connected then
    begin
     ShowMessage ('Connexion échouée !'); exit;
    end;
  Label1.Caption:='Connecté';
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

   //Affichage dans la 2er Grid
   SQLQuery3.SQL.Text:= 'SELECT p.nom, p.domicile, b.prix, b.lieu, b.superficie FROM `proprietaire` p INNER JOIN `biens` b on b.id_proprio = p.proprio_id';
   SQLQuery3.Open;

  Datasource1.Dataset:=SQLQuery1;
  Datasource2.Dataset:=SQLQuery3;

  DBGrid1.DataSource:=DataSource1;
  DBGrid2.DataSource:=DataSource2;
  SQLQuery1.Open;

  Form4.Show;

end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin

end;

procedure TForm1.BT_InsertClick(Sender: TObject);

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


procedure TForm1.Button2Click(Sender: TObject);
     var ID, nom, prenom, domicile, annee_naiss : string;
begin
         ID := (Edit5.Text);
         nom := quotedstr(Edit1.Text);
         prenom := QuotedStr(Edit2.Text);
         domicile := QuotedStr(Edit3.Text);
         annee_naiss := Edit4.Text;
         SQLTransaction1.commit;
         SQlTransaction1.StartTransaction;
         MySQL56Connection1.ExecuteDirect('DELETE FROM proprietaire WHERE proprietaire.proprio_id ='+ID+' and  proprietaire.nom = '+nom+' and proprietaire.prénom = '+prenom+' and proprietaire.domicile = '+domicile+' and proprietaire.année_naiss = '+annee_naiss);
         SQLTransaction1.Commit;

         RefreshSQLQuery1;
         RefreshCombobox1;

         Edit5.Text := '';
         Edit1.Text := '';
         Edit2.Text := '';
         Edit3.Text := '';
         Edit4.Text := '';

         Button2.Enabled := False;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
          Edit5.Text := DBGrid1.Columns[0].Field.Text;
          Edit1.Text := DBGrid1.Columns[1].Field.Text;
          Edit2.Text := DBGrid1.Columns[2].Field.Text;
          Edit3.Text := DBGrid1.Columns[3].Field.Text;
          Edit4.Text := DBGrid1.Columns[4].Field.Text;

          Button2.Enabled := True;
end;

procedure TForm1.BT_AfficherClick(Sender: TObject);

          var nom, domicile, commune, prixMin, prixMax, superficieMin, superficieMax :string;
          var firstRequete, lastRequete, requeteSQL : string;

       begin
         //si rien dans la barre de recherche
         if((Edit6.Text = '')  and
            (Edit7.Text = '')  and
            (Edit8.Text = '')  and
            (Edit9.Text = '')  and
            (Edit10.Text = '') and
            (Edit11.Text = '') and
            (Edit12.Text = ''))
            then
                SQLQuery3.SQL.Text:= 'SELECT p.nom, p.domicile, b.prix, b.lieu, b.superficie FROM `proprietaire` p INNER JOIN `biens` b on b.id_proprio = p.proprio_id';
                SQLQuery3.Open;

         if(Edit6.Text = '') then   nom := '%'
         else                       nom:=  '%'+Edit6.Text+'%';

         if(Edit7.Text = '') then   domicile := '%'
         else                       domicile :=  '%'+Edit7.Text+'%';

         if(Edit8.Text = '') then   commune := '%'
         else                       commune :=  '%'+Edit8.Text+'%';

         if(Edit9.Text = '') then   prixMin := '0'
         else                       prixMin := Edit9.Text;

         if(Edit10.Text = '') then  prixMax := '99999999'
         else                       prixMax := Edit10.Text;

         if(Edit11.Text = '') then  superficieMin := '0'
         else                       superficieMin := Edit11.Text;

         if(Edit12.Text = '') then  superficieMax := '99999999'
         else                       superficieMax := Edit12.Text;

         firstRequete :=  'SELECT p.nom, p.domicile, b.prix, b.lieu, b.superficie FROM `proprietaire` p INNER JOIN `biens` b on b.id_proprio = p.proprio_id WHERE p.nom LIKE "';
         lastRequete := '"';

         requeteSQL :=  firstRequete + nom +'" AND p.domicile LIKE "'+ domicile + '" AND b.lieu LIKE "' + commune + '" AND b.prix >= "' + prixMin + '" AND b.prix <= "' + prixMax + '" AND b.superficie >= "' + superficieMin + '" AND b.superficie <= "' + superficieMax + lastRequete;
        SQLQuery3.Close;
          SQLQuery3.SQL.Text:= requeteSQL;
        SQLQuery3.Open;


       end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     Edit6.Text := '';
     Edit7.Text := '';
     Edit8.Text := '';
     Edit9.Text := '';
     Edit10.Text := '';
     Edit11.Text := '';
     Edit12.Text := '';

     SQLQuery3.Close;
     SQLQuery3.SQL.Text:= 'SELECT p.nom, p.domicile, b.prix, b.lieu, b.superficie FROM `proprietaire` p INNER JOIN `biens` b on b.id_proprio = p.proprio_id';
     SQLQuery3.Open;
end;


procedure TForm1.ComboBox1Change(Sender: TObject);
begin

end;

procedure TForm1.ComboBox1Select(Sender: TObject);
begin
  SQLQuery1.Close;
  if (Combobox1.Text='Tous') then
     SQLQuery1.SQL.Text:= 'SELECT * FROM proprietaire'
  else
     SQLQuery1.SQL.Text:= 'SELECT * FROM proprietaire WHERE domicile="'+ComboBox1.Text+'"';
  SQLQuery1.Open;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  isEditEmptyForAdding();
  isEditEmptyForDelete();
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  isEditEmptyForAdding();
  isEditEmptyForDelete();
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
    isEditEmptyForAdding();
    isEditEmptyForDelete();
end;

procedure TForm1.Edit4Change(Sender: TObject);
begin
  isEditEmptyForAdding();
  isEditEmptyForDelete();
end;

procedure TForm1.Edit5Change(Sender: TObject);
begin
   isEditEmptyForAdding();
   isEditEmptyForDelete();
end;

procedure TForm1.FormCreate(Sender: TObject);
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

procedure TForm1.Label6Click(Sender: TObject);
begin

end;

procedure TForm1.Label7Click(Sender: TObject);
begin

end;

procedure TForm1.Label8Click(Sender: TObject);
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

procedure TForm1.RefreshSQLQuery1();
  begin
   SQLQuery1.Close;
   SQLQuery1.SQL.Text:= 'SELECT * FROM proprietaire';
   SQLQuery1.Open;
  end;

procedure TForm1.RefreshCombobox1();
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



//Si problème avec Edit
//Edit1 and Edit2 exist within the context of the class TForm1. Several instances of this class can exist.
//Therefore you must always specify the instance to which Edit1 and Edit2 belong. Since your class is probably instantiated as Form1 you must mention Form1.Edit1 and Form1.Edit2.
procedure TForm1.isEditEmptyForAdding;

          var ID, nom, prenom, domicile, annee_naiss : string;
  begin
  ID := (Edit5.Text);
  nom := quotedstr(Edit1.Text);
  prenom := QuotedStr(Edit2.Text);
  domicile := QuotedStr(Edit3.Text);
  annee_naiss := Edit4.Text;
   if (     (ID = '')  or
          (nom = '')  or
          (prenom = '')  or
          (domicile = '')  or
          (annee_naiss = '')
      ) then  BT_Insert.Enabled := False
   else
    BT_Insert.Enabled := True;

  end;

procedure TForm1.isEditEmptyForDelete;

          var nom, prenom, domicile, annee_naiss : string;
  begin
  nom := quotedstr(Edit1.Text);
  prenom := QuotedStr(Edit2.Text);
  domicile := QuotedStr(Edit3.Text);
  annee_naiss := Edit4.Text;
   if (   (nom = '')  or
          (prenom = '')  or
          (domicile = '')  or
          (annee_naiss = '')
      ) then  BT_Insert.Enabled := False
   else
    BT_Insert.Enabled := True;

  end;

end.

