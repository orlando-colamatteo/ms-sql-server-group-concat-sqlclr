using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Text;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace GroupConcat.UnitTest
{
    [TestClass()]
    public class GroupConcat : SqlDatabaseTestClass
    {

        public GroupConcat()
        {
            InitializeComponent();
        }

        [TestInitialize()]
        public void TestInitialize()
        {
            base.InitializeTest();
        }
        [TestCleanup()]
        public void TestCleanup()
        {
            base.CleanupTest();
        }

        #region Designer support code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction GROUP_CONCAT_D_DISTINCT_TestAction;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(GroupConcat));
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition ConcatStringIsLen46;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction GROUP_CONCAT_D_DISTINCT_PretestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction GROUP_CONCAT_D_DISTINCT_PosttestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction testInitializeAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction testCleanupAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction GROUP_CONCAT_D_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition ConcatStringLen66;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction GROUP_CONCAT_DISTINCT_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition ConcatStringLen46;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction GROUP_CONCAT_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition StringLen66;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition HasComma;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction GROUP_CONCAT_D_MULTICHAR_DELIMITER_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition ConcatLen49;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition DelimExists;
            this.GROUP_CONCAT_D_DISTINCTData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.GROUP_CONCAT_DData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.GROUP_CONCAT_DISTINCTData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.GROUP_CONCATData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.GROUP_CONCAT_D_MULTICHAR_DELIMITERData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            GROUP_CONCAT_D_DISTINCT_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            ConcatStringIsLen46 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition();
            GROUP_CONCAT_D_DISTINCT_PretestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            GROUP_CONCAT_D_DISTINCT_PosttestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            testInitializeAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            testCleanupAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            GROUP_CONCAT_D_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            ConcatStringLen66 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition();
            GROUP_CONCAT_DISTINCT_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            ConcatStringLen46 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition();
            GROUP_CONCAT_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            StringLen66 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition();
            HasComma = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition();
            GROUP_CONCAT_D_MULTICHAR_DELIMITER_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            ConcatLen49 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition();
            DelimExists = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition();
            // 
            // GROUP_CONCAT_D_DISTINCT_TestAction
            // 
            GROUP_CONCAT_D_DISTINCT_TestAction.Conditions.Add(ConcatStringIsLen46);
            resources.ApplyResources(GROUP_CONCAT_D_DISTINCT_TestAction, "GROUP_CONCAT_D_DISTINCT_TestAction");
            // 
            // ConcatStringIsLen46
            // 
            ConcatStringIsLen46.ColumnNumber = 3;
            ConcatStringIsLen46.Enabled = true;
            ConcatStringIsLen46.ExpectedValue = "46";
            ConcatStringIsLen46.Name = "ConcatStringIsLen46";
            ConcatStringIsLen46.NullExpected = false;
            ConcatStringIsLen46.ResultSet = 1;
            ConcatStringIsLen46.RowNumber = 1;
            // 
            // GROUP_CONCAT_D_DISTINCT_PretestAction
            // 
            resources.ApplyResources(GROUP_CONCAT_D_DISTINCT_PretestAction, "GROUP_CONCAT_D_DISTINCT_PretestAction");
            // 
            // GROUP_CONCAT_D_DISTINCT_PosttestAction
            // 
            resources.ApplyResources(GROUP_CONCAT_D_DISTINCT_PosttestAction, "GROUP_CONCAT_D_DISTINCT_PosttestAction");
            // 
            // testInitializeAction
            // 
            resources.ApplyResources(testInitializeAction, "testInitializeAction");
            // 
            // testCleanupAction
            // 
            resources.ApplyResources(testCleanupAction, "testCleanupAction");
            // 
            // GROUP_CONCAT_D_TestAction
            // 
            GROUP_CONCAT_D_TestAction.Conditions.Add(ConcatStringLen66);
            resources.ApplyResources(GROUP_CONCAT_D_TestAction, "GROUP_CONCAT_D_TestAction");
            // 
            // ConcatStringLen66
            // 
            ConcatStringLen66.ColumnNumber = 3;
            ConcatStringLen66.Enabled = true;
            ConcatStringLen66.ExpectedValue = "66";
            ConcatStringLen66.Name = "ConcatStringLen66";
            ConcatStringLen66.NullExpected = false;
            ConcatStringLen66.ResultSet = 1;
            ConcatStringLen66.RowNumber = 1;
            // 
            // GROUP_CONCAT_D_DISTINCTData
            // 
            this.GROUP_CONCAT_D_DISTINCTData.PosttestAction = GROUP_CONCAT_D_DISTINCT_PosttestAction;
            this.GROUP_CONCAT_D_DISTINCTData.PretestAction = GROUP_CONCAT_D_DISTINCT_PretestAction;
            this.GROUP_CONCAT_D_DISTINCTData.TestAction = GROUP_CONCAT_D_DISTINCT_TestAction;
            // 
            // GROUP_CONCAT_DData
            // 
            this.GROUP_CONCAT_DData.PosttestAction = null;
            this.GROUP_CONCAT_DData.PretestAction = null;
            this.GROUP_CONCAT_DData.TestAction = GROUP_CONCAT_D_TestAction;
            // 
            // GROUP_CONCAT_DISTINCTData
            // 
            this.GROUP_CONCAT_DISTINCTData.PosttestAction = null;
            this.GROUP_CONCAT_DISTINCTData.PretestAction = null;
            this.GROUP_CONCAT_DISTINCTData.TestAction = GROUP_CONCAT_DISTINCT_TestAction;
            // 
            // GROUP_CONCAT_DISTINCT_TestAction
            // 
            GROUP_CONCAT_DISTINCT_TestAction.Conditions.Add(ConcatStringLen46);
            resources.ApplyResources(GROUP_CONCAT_DISTINCT_TestAction, "GROUP_CONCAT_DISTINCT_TestAction");
            // 
            // ConcatStringLen46
            // 
            ConcatStringLen46.ColumnNumber = 3;
            ConcatStringLen46.Enabled = true;
            ConcatStringLen46.ExpectedValue = "46";
            ConcatStringLen46.Name = "ConcatStringLen46";
            ConcatStringLen46.NullExpected = false;
            ConcatStringLen46.ResultSet = 1;
            ConcatStringLen46.RowNumber = 1;
            // 
            // GROUP_CONCATData
            // 
            this.GROUP_CONCATData.PosttestAction = null;
            this.GROUP_CONCATData.PretestAction = null;
            this.GROUP_CONCATData.TestAction = GROUP_CONCAT_TestAction;
            // 
            // GROUP_CONCAT_TestAction
            // 
            GROUP_CONCAT_TestAction.Conditions.Add(StringLen66);
            GROUP_CONCAT_TestAction.Conditions.Add(HasComma);
            resources.ApplyResources(GROUP_CONCAT_TestAction, "GROUP_CONCAT_TestAction");
            // 
            // StringLen66
            // 
            StringLen66.ColumnNumber = 3;
            StringLen66.Enabled = true;
            StringLen66.ExpectedValue = "66";
            StringLen66.Name = "StringLen66";
            StringLen66.NullExpected = false;
            StringLen66.ResultSet = 1;
            StringLen66.RowNumber = 1;
            // 
            // HasComma
            // 
            HasComma.ColumnNumber = 4;
            HasComma.Enabled = true;
            HasComma.ExpectedValue = "1";
            HasComma.Name = "HasComma";
            HasComma.NullExpected = false;
            HasComma.ResultSet = 1;
            HasComma.RowNumber = 1;
            // 
            // GROUP_CONCAT_D_MULTICHAR_DELIMITERData
            // 
            this.GROUP_CONCAT_D_MULTICHAR_DELIMITERData.PosttestAction = null;
            this.GROUP_CONCAT_D_MULTICHAR_DELIMITERData.PretestAction = null;
            this.GROUP_CONCAT_D_MULTICHAR_DELIMITERData.TestAction = GROUP_CONCAT_D_MULTICHAR_DELIMITER_TestAction;
            // 
            // GROUP_CONCAT_D_MULTICHAR_DELIMITER_TestAction
            // 
            GROUP_CONCAT_D_MULTICHAR_DELIMITER_TestAction.Conditions.Add(ConcatLen49);
            GROUP_CONCAT_D_MULTICHAR_DELIMITER_TestAction.Conditions.Add(DelimExists);
            resources.ApplyResources(GROUP_CONCAT_D_MULTICHAR_DELIMITER_TestAction, "GROUP_CONCAT_D_MULTICHAR_DELIMITER_TestAction");
            // 
            // ConcatLen49
            // 
            ConcatLen49.ColumnNumber = 3;
            ConcatLen49.Enabled = true;
            ConcatLen49.ExpectedValue = "49";
            ConcatLen49.Name = "ConcatLen49";
            ConcatLen49.NullExpected = false;
            ConcatLen49.ResultSet = 1;
            ConcatLen49.RowNumber = 1;
            // 
            // DelimExists
            // 
            DelimExists.ColumnNumber = 4;
            DelimExists.Enabled = true;
            DelimExists.ExpectedValue = "1";
            DelimExists.Name = "DelimExists";
            DelimExists.NullExpected = false;
            DelimExists.ResultSet = 1;
            DelimExists.RowNumber = 1;
            // 
            // GroupConcat
            // 
            this.TestCleanupAction = testCleanupAction;
            this.TestInitializeAction = testInitializeAction;
        }

        #endregion


        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        #endregion

        [TestMethod()]
        public void GROUP_CONCAT_D_DISTINCT()
        {
            SqlDatabaseTestActions testActions = this.GROUP_CONCAT_D_DISTINCTData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            try
            {
                // Execute the test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
                SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            }
            finally
            {
                // Execute the post-test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
                SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
            }
        }
        [TestMethod()]
        public void GROUP_CONCAT_D()
        {
            SqlDatabaseTestActions testActions = this.GROUP_CONCAT_DData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            try
            {
                // Execute the test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
                SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            }
            finally
            {
                // Execute the post-test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
                SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
            }
        }
        [TestMethod()]
        public void GROUP_CONCAT_DISTINCT()
        {
            SqlDatabaseTestActions testActions = this.GROUP_CONCAT_DISTINCTData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            try
            {
                // Execute the test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
                SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            }
            finally
            {
                // Execute the post-test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
                SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
            }
        }
        [TestMethod()]
        public void GROUP_CONCAT()
        {
            SqlDatabaseTestActions testActions = this.GROUP_CONCATData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            try
            {
                // Execute the test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
                SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            }
            finally
            {
                // Execute the post-test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
                SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
            }
        }
        [TestMethod()]
        public void GROUP_CONCAT_D_MULTICHAR_DELIMITER()
        {
            SqlDatabaseTestActions testActions = this.GROUP_CONCAT_D_MULTICHAR_DELIMITERData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            try
            {
                // Execute the test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
                SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            }
            finally
            {
                // Execute the post-test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
                SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
            }
        }




        private SqlDatabaseTestActions GROUP_CONCAT_D_DISTINCTData;
        private SqlDatabaseTestActions GROUP_CONCAT_DData;
        private SqlDatabaseTestActions GROUP_CONCAT_DISTINCTData;
        private SqlDatabaseTestActions GROUP_CONCATData;
        private SqlDatabaseTestActions GROUP_CONCAT_D_MULTICHAR_DELIMITERData;
    }
}
