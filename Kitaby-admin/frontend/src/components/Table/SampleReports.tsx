import { mdiOutdoorLamp, mdiTrashCan } from '@mdi/js'
import React, { useEffect, useState } from 'react'
import { Report } from '../../interfaces'
import Button from '../Button'
import Buttons from '../Buttons'
import CardBoxModal from '../CardBox/Modal'

const TableSampleReports = () => {
  const [reports, setReports] = useState<Report[]>([])

  const fetchData = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/admin/getreports', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })
      
      if (!response.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await response.json()
      setReports(data)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }
  useEffect(() => {
    fetchData()
  }, [])
  
  const perPage = 10
  const [currentPage, setCurrentPage] = useState(0)
  const reportsPaginated = reports.slice(perPage * currentPage, perPage * (currentPage + 1))
  const numPages = Math.floor(reports.length / perPage)+1
  const pagesList = []
  for (let i = 0; i < numPages; i++) {
    pagesList.push(i)
  }

  const [isModalUpdateActive, setIsModalUpdateActive] = useState(false)
  const [isModalTrashActive, setIsModalTrashActive] = useState(false)
  const [selectedReport, setSelectedReport] = useState(null)

  const handleUpdateAction = () => {
    setIsModalUpdateActive(false)
  }
  const handleTrashAction = () => {
    setIsModalTrashActive(false)
  }

  const handleDeleteAction = (_id: string) => {
    setIsModalTrashActive(true)
    setSelectedReport(_id)
  }
  const handleAcceptAction = (_id: string) => {
    setIsModalUpdateActive(true)
    setSelectedReport(_id)
  }

  const confirmDeleteAction = async () => {
    try {
      const response = await fetch(`http://localhost:3000/api/admin/deletereported/${selectedReport}`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
      })

      if (!response.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await response.json()
      setReports(data)
      setIsModalTrashActive(false)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }

  const confirmBanAction = async () => {
    try {
      const response = await fetch(`http://localhost:3000/api/admin/banuser/${selectedReport}`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })

      if (!response.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await response.json()
      setReports(data)
      setIsModalUpdateActive(false)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }
  return (
    <div className='mx-3'>
      <CardBoxModal
        title="Sample modal"
        buttonColor="danger"
        buttonLabel="Done"
        isActive={isModalUpdateActive}
        onConfirm={confirmBanAction}
        onCancel={handleUpdateAction}
      >
        <p>
          You are going to ban this user from the app iternally, <b>Are you sure?</b>
        </p>
        
      </CardBoxModal>

      <CardBoxModal
        title="Please confirm"
        buttonColor="danger"
        buttonLabel="Confirm"
        isActive={isModalTrashActive}
        onConfirm={confirmDeleteAction}
        onCancel={handleTrashAction}
      >
        <p>
          Are you sure you want to delete this reported comment? 
        </p>
        
      </CardBoxModal>

      <table className=''>
        <thead>
          <tr>
            <th />
            <th> Report description</th>
            <th>reported</th>
            <th>Reporters</th>
            <th>reports</th>
            <th>Ban/Delete</th>
            <th />
          </tr>
        </thead>
        <tbody>
          {reportsPaginated.map((report: any, index) => (
            <tr key={report.id}>
              <td className="border-b-0 lg:w-6 before:hidden">{index + 1}</td>
              <td data-label="report Name">{report.description}</td>
              <td data-label="Location">{report.reported}</td>
              <td data-label="Q-Reservation" className="lg:w-1 whitespace-nowrap">
                {report.reporters}
              </td>
              <td data-label="Q-Exchange" className="lg:w-1 whitespace-nowrap">
                {report.reports}
              </td>
              <td className="before:hidden lg:w-1 whitespace-nowrap">
                <Buttons type="justify-start lg:justify-end" noWrap>
                  <Button
                    color="danger"
                    icon={mdiTrashCan}
                    onClick={() => handleAcceptAction(report._id)}
                  />
                  <Button
                    color="danger"
                    icon={mdiTrashCan}
                    onClick={() => handleDeleteAction(report._id)}
                  />
                </Buttons>
              </td>
              
            </tr>
          ))}
        </tbody>
      </table>

      {/*Pagination stuff */}
      <div className="p-3 lg:px-6 border-t border-gray-100 dark:border-slate-800">
        <div className="flex flex-col md:flex-row items-center justify-between py-3 md:py-0">
          <Buttons>
            {pagesList.map((page) => (
              <Button
                key={page}
                active={page === currentPage}
                label={page + 1}
                color={page === currentPage ? 'lightDark' : 'whiteDark'}
                small
                onClick={() => setCurrentPage(page)}
              />
            ))}
          </Buttons>
          <small className="mt-6 md:mt-0">
            Page {currentPage + 1} of {numPages}
          </small>
        </div>
      </div>
    </div>
  )
}

export default TableSampleReports;
