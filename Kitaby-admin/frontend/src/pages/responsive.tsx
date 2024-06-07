import Head from 'next/head'

import React, { ReactElement,useState,useEffect } from 'react'
import LayoutAuthenticated from '../layouts/Authenticated'
import SectionMain from '../components/Section/Main'
import SectionTitle from '../components/Section/Title'
import { appTitle, getPageTitle } from '../config'
import TableSampleBibRegistrations from '../components/Table/SampleLibRegistration'
import { mdiTableBorder } from '@mdi/js'
import CardBox from '../components/CardBox'
import { Field, Form, Formik } from 'formik'
const ResponsivePage = () => {
  const [bibInfo, setBibInfo] = useState(null)
  const [name, setName] = useState(null)
  useEffect(() => {
    const fetchData = async (name) => {
      try {
        const response = await fetch(`http://localhost:3000/api/admin/getuserinfo/${name}`, {
          method: 'GET',
          headers: { 'Content-Type': 'application/json' },
        })
        const data = await response.json() // Extract JSON data from response
        setBibInfo(data) // Update state with fetched book info
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    }

    // Fetch data when title changes
    fetchData(name)
  }, [name])
  const handleSearch = (values) => {
    setName(values.userName)
  }

  return (
    <>
      <Head>
        <title>{getPageTitle('Responsive')}</title>
      </Head>

      <SectionMain>
        

        

        <CardBox className="mb-6" hasTable>
          <TableSampleBibRegistrations />
        </CardBox>

        {/* <SectionTitleLineWithButton icon={mdiTableOff} title="Empty variation" /> */}

        

        {/* <CardBox>
          <CardBoxComponentEmpty />
        </CardBox> */}
      </SectionMain>
      <Formik initialValues={{ bibName: '' }} onSubmit={handleSearch}>
        <Form>
          <Field name="userName" type="text" className="rounded-xl mx-4" />
          <button type="submit">Search</button>
        </Form>
      </Formik>
      <div className="h-auto p-4 bg-white dark:bg-gray-800 rounded shadow">
  {bibInfo && (
    <div className="space-y-2">
      <h2 className="text-xl font-bold text-gray-800">bib Information</h2>
      <p className="text-gray-700">
        <span className="font-semibold">name: </span> {bibInfo.name}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Phone number: </span> {bibInfo.Phone}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Registre commerciale: </span> {bibInfo.com_reg_num}
      </p>
      
      
    </div>
  )}
</div>
    </>
  )
}

ResponsivePage.getLayout = function getLayout(page: ReactElement) {
  return <LayoutAuthenticated>{page}</LayoutAuthenticated>
}

export default ResponsivePage
